import React, { useState, useEffect, useRef, MutableRefObject } from "react";
import ReactSwipe from "react-swipe";
import {
  useOutsideClickObserver,
  useLiteEventObserver,
  useWindowSize
} from "../../utils/hooks";
import SwipeItemChildren from "./SwipeItemChildren";
import { Sentence } from "../../models";
import styled, { css } from "styled-components";
import ReaderStore from "../../stores/ReaderStore";
import "./Reader.css";
import { isPlatform } from "@ionic/react";

const Main = styled.div`
  padding: 10px 5px;
  height: calc(100% - 20px);
  overflow: hidden;
  width: calc(100vw - 10px);
`;


const Swipe = styled(ReactSwipe)`
  overflow: hidden;
  height: 100%;
  width: calc(100vw - 10px) !important;

  & > div {
    display: block !important;
    height: 100%;
  }

  & > * > div {
    height: 100%;
    width: calc(100vw - 10px) !important;
  }`;

const SwipeItem = styled.div`
  max-height: 100%;
  height: 100%;
  width: 100vw;
  overflow: hidden;
`;


interface Props {
  sentences: Sentence[];
  readerStore: ReaderStore
}

export const readerContext = React.createContext<ReaderStore | null>(null);

// thanks to  https://github.com/yoo2001818
const Reader: React.FC<Props> = (props: Props) => {
  const sentences = props.sentences;
  const [loaded, setLoaded]: [boolean, any] = useState(false);
  const rendered = useRef(false);
  const [cutted, setCutted] = useState(false);

  console.log(cutted,loaded);
  const [dividePositions, setDividePositions]: [any, any] = useState<number[]>([]);
  const swipeItemRefs: any = useRef([]);

  const swipeRef: MutableRefObject<ReactSwipe | null> = useRef(null);
  const idToPage = useRef(new Map());
  const readingSentence: MutableRefObject<string> = useRef(
    props.readerStore.location.sentenceId
  );

  const getPageSentences = (page: number) => {
    if (page === dividePositions.length) {
      return sentences.slice(dividePositions[page - 1] || 0);
    }
    return sentences.slice(
      dividePositions[page - 1] || 0,
      dividePositions[page]
    );
  };

  const atHandle = () => {
    const readingPage = idToPage.current.get(readingSentence.current) || 0;
    // if (readingPage === 0) {
    //   window.app.atStart();
    // }
    // if (readingPage === dividePositions.length) {
    //   window.app.atEnd();
    // }
    // if (readingPage !== 0 && readingPage !== dividePositions.length) {
    //   window.app.atMiddle();
    // }
    if (cutted) {
      props.readerStore.location.sentenceId =  readingSentence.current;
    }
  };


  useWindowSize(() => {
    console.log('window');
    setCutted(false);
    setDividePositions([]);
  });

  // useEffect(() => {
  //   if (cutted.current) {
  //     // window.app.setLoading(false);
  //     atHandle();
  //   }
  // });

  useEffect(() => {
    window.requestAnimationFrame(() => {
      setLoaded(true);
    });
  }, []);

  useEffect(() => {
    // 마지막 페이지의 자를 노드 위치 계산
    // debugger;
    if (!loaded) return;
    if (cutted) return;
    const lastItem = swipeItemRefs.current[0];
    const parentBounds = lastItem.getBoundingClientRect();
    const parentTop = parentBounds.top;
    const parentHeight = parentBounds.height;
    let pageTop = parentTop;
    let currentPage = 0;
    let cutPos: any = [];
    // HTMLElement.children은 놀랍게도 배열이 아니라서 findIndex같은걸 못써요 ㅠㅠ
    for (let i = 0; i < lastItem.children.length; i += 1) {
      const childNode = lastItem.children[i]!;
      const childBounds = childNode.getBoundingClientRect()!;
      const offset = childBounds.bottom - pageTop + 20;
      if (offset >= parentHeight) {
        pageTop = (lastItem.children[i - 1] || lastItem.children[i]).getBoundingClientRect().bottom;
        // 노드 위치는 dividePositions의 마지막 값만큼 뒤로 가있기 때문에 앞으로 다시
        // 밀어주는 작업이 필요함
        cutPos[currentPage] = i;
        currentPage += 1;
      }
    }
    const getPageSentencesByCutPos = (page: number) => {
      if (page === cutPos.length) {
        return sentences.slice(cutPos[page - 1] || 0);
      }
      return sentences.slice(
        cutPos[page - 1] || 0,
        cutPos[page]
      );
    };
    readingSentence.current = props.readerStore.location.sentenceId;
    idToPage.current = Array(cutPos.length + 1)
        .fill(1)
        .flatMap((_: any, i: number) =>
          getPageSentencesByCutPos(i).map(sen => [sen.id, i])
        )
        .reduce((map: Map<string, number>, tuple: any) => {
          map.set(tuple[0], tuple[1]);
          return map;
        }, new Map());

      setDividePositions(cutPos);
      setCutted(true);
  }, [cutted, loaded]);


  // useLiteEventObserver(
  //   window.webapp.onFlushPaginate,
  //   () => {
  //     const current = idToPage.current.get(readingSentence.current) || 0;
  //     window.app.paginate(getPageSentences(current).map(s => s.id));
  //   },
  //   []
  // );
  console.log(readingSentence.current, dividePositions.length, idToPage.current);
  const swipeOptions = {
    startSlide: idToPage.current.get(readingSentence.current) || 0,
    continuous: false,
    callback: () => {
      if (swipeRef.current) {
        console.log("swipe")
        const sens = getPageSentences(swipeRef.current.getPos());
        const old = idToPage.current.get(readingSentence.current) || 0;
        const neww = idToPage.current.get(sens[0].id) || 0;
        if (cutted) {
          readingSentence.current = sens[0].id;
        }
        if (neww > old) {
          // window.app.paginate(getPageSentences(old).map(s => s.id));
        }
        // window.webapp.cancelSelect();
        // atHandle();
      }
    }
  };

  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      console.log(e.code, loaded, cutted);
      if (loaded && cutted) {
        if (e.code === 'ArrowRight') {
          console.log(dividePositions.length);
          console.log("next");
          if (swipeRef.current.getPos() === dividePositions.length) {
            props.readerStore.nextChapter();
          } else {
            swipeRef.current.next();
          }

        } else if (e.code === 'ArrowLeft') {
          if (swipeRef.current.getPos() === 0) {
            props.readerStore.prevChapter();
          } else {
            swipeRef.current.prev();
          }
        } else if (e.code === 'Escape') {

        }
      }
    };
    document.addEventListener('keydown', handler);
    return () => {
      document.removeEventListener('keydown', handler);
    };
  }, [loaded, cutted]);

  return (
    <readerContext.Provider value={props.readerStore}>
      <Main>
        <Swipe
          swipeOptions={swipeOptions}
          ref={r => (swipeRef.current = r)}
          childCount={dividePositions.length + 1}
        >
          {loaded && Array(dividePositions.length + 1)
            .fill(1)
            .map((_: any, i: number) => (
              <SwipeItem
                style={{cursor: !isPlatform('electron') ? 'pointer':undefined}}
                key={i}
                ref={node => {
                  swipeItemRefs.current[i] = node;
                }}
              >
                <SwipeItemChildren sentences={getPageSentences(i)} />
              </SwipeItem>
            ))}
        </Swipe>
      </Main>
    </readerContext.Provider>
  );
};

export default Reader;
