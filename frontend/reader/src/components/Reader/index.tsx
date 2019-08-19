import React, { useState, useEffect, useRef, MutableRefObject } from "react";
import ReactSwipe from "react-swipe";
import {
  useOutsideClickObserver,
  useLiteEventObserver
} from "../../utills/hooks";
import SwipeItemChildren from "../SwipeItemChildren";
import { Sentence } from "../../model";
import styled, { css } from "styled-components";

const Main = styled.div`
  height: calc(100vh - 20px);
  padding: 10px 0;
  width: 100%;
`;

const SwipeItem = styled.div`
  max-height: 100%;
  height: 100%;
  overflow: hidden;
`;

const Swipe = styled(ReactSwipe)<{ loading: boolean }>`
  overflow: hidden;
  height: 100%;
  width: 100%;
  & > div {
    height: 100%;
  }

  & > * > div {
    height: 100%;
  }

  ${props =>
    props.loading &&
    css`
      opacity: 0;
      pointer-events: none;
    `}
`;

interface Props {
  sentences: Sentence[];
  readingSentence: string;
}

// thanks to  https://github.com/yoo2001818
const Reader: React.FC<Props> = (props: Props) => {
  const sentences = props.sentences;
  const [_dividePositions, setDividePositions]: [any, any] = useState<number[]|null>(null);
  const swipeItemRefs: any = useRef([]);

  const swipeRef: MutableRefObject<ReactSwipe | null> = useRef(null);
  const idToPage = useRef(new Map());
  const readingSentence: MutableRefObject<string> = useRef(
    props.readingSentence
  );

  const dividePositions = _dividePositions || [];

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
    if (readingPage === 0) {
      window.app.atStart();
    }
    if (readingPage === dividePositions.length) {
      window.app.atEnd();
    }
    if (readingPage !== 0 && readingPage !== dividePositions.length) {
      window.app.atMiddle();
    }
    window.app.readingSentenceChange(readingSentence.current);
  };

  useEffect(() => {
    if (readingSentence.current !== props.readingSentence) {
      atHandle();
      window.app.setLoading(false);
      return () => {
        window.app.setLoading(true);
      }
    }
  });

  useEffect(() => {
    // 마지막 페이지의 자를 노드 위치 계산
    const lastItem = swipeItemRefs.current[0];
    const parentBounds = lastItem.getBoundingClientRect();
    const parentTop = parentBounds.top;
    const parentHeight = parentBounds.height;
    const prevPos = 0;
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
    const getPageSentencesByCutPos = (page: number) => {
      if (page === cutPos.length) {
        return sentences.slice(cutPos[page - 1] || 0);
      }
      return sentences.slice(
        cutPos[page - 1] || 0,
        cutPos[page]
      );
    };
    readingSentence.current = props.readingSentence;
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
  }, [props]);

  useLiteEventObserver(
    window.webapp.onFlushPaginate,
    () => {
      const current = idToPage.current.get(readingSentence.current) || 0;
      window.app.paginate(getPageSentences(current).map(s => s.id));
    },
    []
  );

  const swipeOptions = {
    startSlide: idToPage.current.get(readingSentence.current) || 0,
    continuous: false,
    callback: () => {
      if (swipeRef.current) {
        const sens = getPageSentences(swipeRef.current.getPos());
        const old = idToPage.current.get(readingSentence.current) || 0;
        const neww = idToPage.current.get(sens[0].id) || 0;
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
    <Main>
      <Swipe
        loading={readingSentence.current !== props.readingSentence}
        swipeOptions={swipeOptions}
        ref={r => (swipeRef.current = r)}
        childCount={dividePositions.length + 1}
      >
        {Array(dividePositions.length + 1)
          .fill(1)
          .map((_: any, i: number) => (
            <SwipeItem
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
  );
};

export default Reader;
