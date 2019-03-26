package main

import (
	"errors"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"regexp"
	"strings"
	"sync"
	"time"
    "os/exec"
	"runtime"
	
	http "github.com/hashicorp/go-retryablehttp"
	"github.com/PuerkitoBio/goquery"
)

const (
	SrcDonga = iota
	SrcOxford
	SrcAbbr
	SrcGong
	SrcYBM
)

var clear map[string]func() //create a map for storing clear funcs

func init() {
    clear = make(map[string]func()) //Initialize it
    clear["linux"] = func() { 
        cmd := exec.Command("clear") //Linux example, its tested
        cmd.Stdout = os.Stdout
        cmd.Run()
    }
    clear["windows"] = func() {
        cmd := exec.Command("cmd", "/c", "cls") //Windows example, its tested 
        cmd.Stdout = os.Stdout
        cmd.Run()
    }
}

func callClear() {
    value, ok := clear[runtime.GOOS] //runtime.GOOS -> linux, windows, darwin etc.
    if ok { //if we defined a clear func for that platform:
        value()  //we execute it
    } else { //unsupported platform
        panic("Your platform is unsupported! I can't clear terminal screen :(")
	}
}

var otherdict = make(map[string]int)
var completed = make(map[int]bool)
var list = []string{}
var mu = &sync.Mutex{}
var seen = make(map[string]bool)
var send = make(chan Word)
var dict = make(map[string]map[int]Word)


type Example struct {
	First  string `json:"foreign"`
	Second string `json:"native"`
}

type Def struct {
	Pos      string    `json:"pos"`
	Def      string    `json:"def"`
	Examples []Example `json:"examples"`
}

type Word struct {
	Word string `json:"word"`
	Src  int `json:"src"`
	Pron string `json:"pron"`
	Defs []Def  `json:"defs"`
}

func getBody(url string) io.ReadCloser {
	client := http.NewClient()
	client.Logger = nil
	request, err := http.NewRequest("GET", url, nil)
	if err != nil {
		log.Println(err.Error())
		return nil
	}
	request.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36")
	resp, err := client.Do(request)
	if err != nil {
		log.Println(err.Error())
		return nil
	}
	return resp.Body
}

func getDefinition(word string, url string, primary bool, source string) error {
	mu.Lock()
	if _, ok := seen[source]; ok {
		mu.Unlock()
		return nil
	}
	seen[source] = true
	mu.Unlock()

	body := getBody(url)
	if body == nil {
		return errors.New("ERROR")
	}
	defer body.Close()

	doc, err := goquery.NewDocumentFromReader(body)
	if err != nil {
		log.Println(err.Error())
		return errors.New("ERROR")
	}

	src := doc.Find(".dicType").After(".box_wrap1").First()
	if src == nil {
		// log.Println("returning")
		return nil
	}

	str := src.Text()
	str = strings.Trim(str, " ")
	var src2 int
	if strings.Contains(str, "Oxford Advanced Learner's English-Korean Dictionary") {
		src2 = SrcOxford
	} else if strings.Contains(str, "Dong-a's Prime English-Korean Dictionary") {
		src2 = SrcDonga
	} else if strings.Contains(str, "이공학 표준영어사전") {
		src2 = SrcGong
	} else if strings.Contains(str, "YBM All in All") {
		src2 = SrcYBM
	} else {
		mu.Lock()
		otherdict[str] = otherdict[str] + 11
		mu.Unlock()
		return nil
	}
	// log.Println("source:", source)
	wor := Word{
		Word: word,
		Src: src2,
		Pron: "",
		Defs: []Def{},
	}

	doc.Find(".box_wrap1").Each(func(i int, s *goquery.Selection) {
		part := s.Find("h3 .fnt_syn").First().Text()
		s.Find("dl dt").Each(func(i int, ss *goquery.Selection) {
			base := ss.Find("em").First()
			verbType := base.Find(".fnt_k04").Text()
			input := base.Find(".fnt_k05, .fnt_k06, fnt_k09").Text()
			re_leadclose_whtsp := regexp.MustCompile(`^[\s\p{Zs}]+|[\s\p{Zs}]+$`)
			re_inside_whtsp := regexp.MustCompile(`[\s\p{Zs}]{2,}`)
			final := re_leadclose_whtsp.ReplaceAllString(input, "")
			final = re_inside_whtsp.ReplaceAllString(final, " ")
			def := Def{
				Pos:      part,
				Def:      final,
				Examples: []Example{},
			}
			if strings.Contains(verbType, "[자동사") {
				def.Pos = "자동사"
			}
			if strings.Contains(verbType, "[타동사") {
				def.Pos = "타동사"
			}
			ss.NextUntil("dt").Each(func(i int, sss *goquery.Selection) {
				eng := ""
				kor := ""
				sss.Find("p span").Each(func(i int, ssss *goquery.Selection) {
					if i == 0 {
						eng = ssss.Text()
					} else {
						kor = ssss.Text()
					}
				})
				def.Examples = append(def.Examples, Example{First: eng, Second: kor})
			})
			wor.Defs = append(wor.Defs, def)
		})
	})
	send <- wor
	return nil
}

func getQuery(word string, index int) {
	body := getBody("http://endic.naver.com/search.nhn?sLn=kr&query=" + word)
	if body == nil {
		mu.Lock()
		completed[index] = false
		mu.Unlock()
		return
	}
	defer body.Close()
	doc, err := goquery.NewDocumentFromReader(body)
	if err != nil {
		log.Println(err.Error())
		mu.Lock()
		completed[index] = false
		mu.Unlock()
		return
	}

	mu.Lock()
	completed[index] = true
	mu.Unlock()

	doc.Find(".word_num").Each(func(i int, s *goquery.Selection) {
		sect, _ := s.Find("h3 img").First().Attr("alt")
		if sect == "단어/숙어" {
			s.Find(".list_e2 dt span a").Each(func(i int, s *goquery.Selection) {
				href, _ := s.Attr("href")
				pat := regexp.MustCompile("entryId=([^&]+)")
				res := pat.FindAllStringSubmatch(href, -1)
				text := s.Not("sup").Text()
				text = strings.ToLower(text)
				if len(res) == 1 {
					err := getDefinition(text, "http://endic.naver.com"+href, true, res[0][0])
					if err != nil {
						mu.Lock()
						completed[index] = false
						mu.Unlock()
					}
				}
			})
		}
	})
}

var wg sync.WaitGroup
var wg2 sync.WaitGroup

func worker(input chan int) {
	for index := range input {
		word := list[index]
		getQuery(word, index)
	}
	wg.Done()
}

func worker2() {
	n := 0
	for item := range send {
		mu.Lock()
		if _, ok := dict[item.Word]; !ok {
			dict[item.Word] = make(map[int]Word)
			dict[item.Word][item.Src] = item
		} else if _, ok := dict[item.Word][item.Src]; !ok {
			dict[item.Word][item.Src] = item
		} else {
			var word = dict[item.Word][item.Src]
			for _, new := range item.Defs {
				var isnew = true
				for _, old := range word.Defs {
					if new.Def == old.Def {
						isnew = false
						break
					}
				}
				if isnew {
					word.Defs = append(word.Defs, new)
				}
			}
			dict[item.Word][item.Src] = word
		}
		n ++
		mu.Unlock()
		if n % 10000 == 0 {
			writeFile(time.Now().String())
		}
	}
	wg2.Done()
}

func writeFile(t string) {
	buf, _ := json.Marshal(dict)
	err := ioutil.WriteFile("output" + t + ".json", buf, 0644)
	if err != nil {
		panic(err)
	}

	mu.Lock()
	buf2, _ := json.Marshal(completed)
	err = ioutil.WriteFile("completed" + t + ".json", buf2, 0644)
	if err != nil {
		panic(err)
	}
	mu.Unlock()
}

func progress(total int) {
	t := time.NewTicker(time.Second)
	for _ = range t.C {
		callClear()
		mu.Lock()
		var success = 0
		var fail = 0
		for _, val := range completed {
			if val {
				success ++
			} else {
				fail ++
			}
		}
		fmt.Println("success:", success, "fail:", fail, "total:", total, "dict:", len(dict))
		mu.Unlock()
	}
}


func main() {
	txt, err := ioutil.ReadFile("words.txt")
	if err != nil {
		fmt.Println(err)
		return
	}
	file, err := os.Create("log.txt")
	if err != nil {
		fmt.Println(err)
		return
	}
	t := time.Now()
	mw := io.MultiWriter(os.Stdout, file)
	log.SetOutput(mw)
	list = strings.Split(string(txt), "\n")
	list = list[:len(list)-1]
	log.Printf("%d entries inputed\n", len(list))

	input := make(chan int, 20)
	for i := 0; i < 100; i++ {
		go worker(input)
		wg.Add(1)
	}
	go worker2()
	wg2.Add(1)

	go progress(len(list))

	for index := range list {
		input <- index
	}
	close(input)
	wg.Wait()
	close(send)
	wg2.Wait()
	writeFile("")

	for str, n := range otherdict {
		log.Println(str, "  :   ", n)
	}
	log.Println(otherdict)
	log.Println(len(dict))
	log.Println("done")
	log.Println(time.Now().Sub(t).Minutes(), " minutes")
	log.Println("exiting")
}
