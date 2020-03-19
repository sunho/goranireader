import React, { useState, useEffect, useRef, MutableRefObject, useContext } from "react";
import styled, { css } from "styled-components";
import "./Reader.css";
import { isPlatform, IonProgressBar, IonContent, IonSpinner } from "@ionic/react";
import { ReaderContext } from "../../pages/ReaderPage";
import { reaction, untracked } from "mobx";
import Page from "./Page";
import { useObserver, observer } from "mobx-react-lite";
import Swiper from 'react-id-swiper';
import 'swiper/css/swiper.css';
import { useWindowSize } from "../../utils/hooks";

const Main = styled.div<{ font: number }>`
  height: 100%;
  font-size: ${props => props.font}px;
`;
const Cover = styled.div<{ enabled: Boolean; }>`
  width: 100%;
  height: 100%;
  z-index: 2;
  position: fixed;
  background: white;
  cursor: pointer;
  display: block;
  ${props => ((props.enabled) && css`
    display: none;
  `)}
`;

const Reader = observer(() => {
  const readerRootStore = useContext(ReaderContext);
  const { readerStore, readerUIStore } = readerRootStore;
  const { dividePositions, cutted, loaded } = readerUIStore;
  const pageRefs: any = useRef([]);
  const swipeRef: MutableRefObject<any | null> = useRef(null);
  const readingSentence = untracked(()=>(readerStore.location.sentenceId));

  useEffect(() => {
    if (swipeRef.current?.$el) {
      swipeRef.current.update();
    }
    if (!loaded) return;
    if (cutted) return;
    const lastItem = pageRefs.current[0];
    const parentBounds = swipeRef.current.$el[0].getBoundingClientRect();
    const parentTop = parentBounds.top;
    const parentHeight = parentBounds.height;
    let pageTop = parentTop;
    let currentPage = 0;
    let cutPos: any = [];
    for (let i = 0; i < lastItem.children.length; i += 1) {
      const childNode = lastItem.children[i]!;
      const childBounds = childNode.getBoundingClientRect()!;
      const offset = childBounds.bottom - pageTop + 20;
      if (offset >= parentHeight) {
        pageTop = (lastItem.children[i - 1] || lastItem.children[i]).getBoundingClientRect().bottom;
        cutPos[currentPage] = i;
        currentPage += 1;
      }
    }
    readerUIStore.dividePositions = cutPos;
    readerUIStore.cutted = true;
  });

  const rerender = () => {
    setTimeout(() => {
      if (!swipeRef.current?.$el) {
        rerender();
        return;
      }
      if (swipeRef.current.$el[0].getBoundingClientRect().height === 0) {
        rerender();
        return;
      }
      if (pageRefs.current.length === 0) {
        rerender();
        return;
      }
      readerUIStore.loaded = true;
    }, 50);
  };

  useEffect(() => {
    rerender();
  }, []);

  useEffect(() => {
    const handler = () => {
      const page = swipeRef.current.activeIndex;
      if (page === 0) {
        if (readerStore.currentChapterIndex !== 0) {
          setTimeout(readerUIStore.prevChapter, 0.1);
        }
      } else if (page === dividePositions.length + 2) {
        if (readerStore.currentChapterIndex !== readerStore.book.chapters.length -1) {
          setTimeout(readerUIStore.nextChapter, 0.1);
        }
      } else {
        untracked(()=>{readerUIStore.changePage(swipeRef.current.activeIndex - 1)});
      }
    };

    if (swipeRef.current?.$el) {
      swipeRef.current.slideTo(readerUIStore.getPageBySentenceId(readingSentence) + 1, 0);
      swipeRef.current.on("slideChange", handler);
      return () => {
        swipeRef.current.off("slideChange", handler);
      }
    }
  });

  useWindowSize(() => {
    readerUIStore.clearDivision();
    rerender();
  });

  reaction(() => readerUIStore.fontSize, () =>{
    readerUIStore.clearDivision();
    rerender();
  });

  const params = {
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
    allowTouchMove: !isPlatform('electron'),
    preventInteractionOnTransition: true,
    spaceBetween: 30,
  }

  const pages = Array(dividePositions.length + 1)
    .fill(1)
    .map((_: any, i: number) => (
      <Page
        key={i}
        ref={node => {
          pageRefs.current[i] = node;
        }}
        sentences={readerUIStore.getPageSentences(i)}
      />
    ));

  return (
    <Main font={readerUIStore.fontSize}>
      <Cover enabled={(loaded && cutted)}>
        <IonSpinner name="crescent"/>
      </Cover>
      <Swiper key={dividePositions.length} {...params} getSwiper={(node) => {swipeRef.current = node}}>
        {([<div key="start"></div>].concat(pages).concat([<div key="end"></div>]))}
      </Swiper>
    </Main>
  );
});

export default Reader;
