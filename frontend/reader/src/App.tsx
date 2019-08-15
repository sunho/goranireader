import React, { useState, useEffect, useRef, MutableRefObject } from "react";
import logo from "./logo.svg";
import ReactSwipe from "react-swipe";
import "./App.css";
import { useOutsideClickObserver, useLiteEventObserver } from "./hooks";
import SwipeItem from "./SwipeItem";
import { Sentence } from "./model";

interface Props {
  sentences: Sentence[];
  readingSentence: string;
}

// thanks to  https://github.com/yoo2001818
const App: React.FC<Props> = (props: Props) => {
  const data = props.sentences;
  const [dividePositions, setDividePositions]: [any, any] = useState([]);
  const swipeItemRefs: any = useRef([]);
  const swipeRef: MutableRefObject<ReactSwipe | null> = useRef(null);
  const [idToPage, setIdToPage]: [any, any] = useState(new Map());
  const readingSentence: MutableRefObject<string> = useRef(data[0].id || props.readingSentence);

  const getPageSentences = (page: number) => {
    if (page === dividePositions.length) {
      return data.slice(dividePositions[page - 1] || 0);
    }
    return data.slice(dividePositions[page - 1] || 0, dividePositions[page])
  };

  useEffect(() => {
    // 마지막 페이지의 자를 노드 위치 계산
    const lastItem = swipeItemRefs.current[dividePositions.length];
    const parentBounds = lastItem.getBoundingClientRect();
    const parentTop = parentBounds.top;
    const parentHeight = parentBounds.height;
    const prevPos = dividePositions[dividePositions.length - 1] || 0;
    let pageTop = parentTop;
    let currentPage = 0;
    let cutPos: any = [];
    // HTMLElement.children은 놀랍게도 배열이 아니라서 findIndex같은걸 못써요 ㅠㅠ
    for (let i = 0; i < lastItem.children.length; i += 1) {
      const childNode = lastItem.children[i];
      const childBounds = childNode.getBoundingClientRect();
      const offset = childBounds.bottom - pageTop;
      if (offset >= parentHeight) {
        pageTop = lastItem.children[i - 1].getBoundingClientRect().bottom;
        // 노드 위치는 dividePositions의 마지막 값만큼 뒤로 가있기 때문에 앞으로 다시
        // 밀어주는 작업이 필요함
        cutPos[currentPage] = i + prevPos;
        currentPage += 1;
      }
    }
    // 자를게 있다면 절단
    if (cutPos.length > 0) {
      setDividePositions((prevState: any) => [...prevState, ...cutPos]);
    }
  }, [dividePositions]);

  const atHandle = () => {
    const readingPage = idToPage.get(readingSentence.current) || 0;
    if (readingPage === 0) {
      window.app.atStart();
    }
    if (readingPage === dividePositions.length) {
      window.app.atEnd();
    }
    if (readingPage !== 0 && readingPage !== dividePositions.length) {
      window.app.atMiddle();
    }
  };

  useLiteEventObserver(window.webapp.onFlushPaginate, () => {
    const current = idToPage.get(readingSentence.current) || 0;
    window.app.paginate(getPageSentences(current).map(s => s.id));
  }, []);

  useEffect(() => {
    setIdToPage(Array(dividePositions.length + 1).fill(1).flatMap((_ :any, i: number) => (
     getPageSentences(i).map(sen => (
      [sen.id, i]
     ))
    )).reduce((map: Map<string, number>, tuple: any) => {
      map.set(tuple[0], tuple[1]);
      return map;
    }, new Map()));
    atHandle();
  }, [dividePositions]);

  useEffect(() => {
    function handleResize() {
      setDividePositions([]);
    }
    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize", handleResize);
  }, []);

  const swipeOptions = {
    startSlide: idToPage.get(readingSentence.current) || 0,
    continuous: false,
    callback: () => {
      if (swipeRef.current) {
        const sens = getPageSentences(swipeRef.current.getPos());
        const old = idToPage.get(readingSentence.current) || 0;
        const neww = idToPage.get(sens[0].id) || 0;
        readingSentence.current = sens[0].id;
        if (neww > old) {
          window.app.paginate(getPageSentences(old).map(s => s.id));
        }
        window.webapp.cancelSelect();
        atHandle();
      }
    }
  };

  return (
    <div className="App">
      <ReactSwipe
        className="Swipe"
        swipeOptions={swipeOptions}
        ref={r => (swipeRef.current = r)}
        childCount={dividePositions.length + 1}
      >
        {Array(dividePositions.length + 1).fill(1).map((_: any, i: number) => (
          <div className="SwipeItem" key={i} ref={node => {swipeItemRefs.current[i] = node}}>
            <SwipeItem sentences={getPageSentences(i)}/>
          </div>
        ))}
      </ReactSwipe>
    </div>
  );
};

export default App;
