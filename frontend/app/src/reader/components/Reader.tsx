import React, {
  useState,
  useEffect,
  useRef,
  MutableRefObject,
  useContext,
  useCallback
} from "react";
import styled, { css } from "styled-components";
import "./Reader.css";
import {
  isPlatform,
  IonProgressBar,
  IonContent,
  IonSpinner
} from "@ionic/react";
import { reaction, untracked } from "mobx";
import Page from "./Page";
import { useObserver } from "mobx-react";
import Swiper from "react-id-swiper";
import "swiper/css/swiper.css";
import { useWindowSize } from "../../core/utils/hooks";
import { ReaderContext } from "../stores/ReaderRootStore";
import Dict from "./Dict";

const Main = styled.div<{ font: number }>`
  height: 100%;
  font-size: ${props => props.font}px;
`;

const Cover = styled.div<{ enabled: Boolean }>`
  width: 100%;
  height: 100%;
  z-index: 2;
  position: fixed;
  background: var(--ion-background-color);
  cursor: pointer;
  display: block;
  ${props =>
    props.enabled &&
    css`
      display: none;
    `}
`;

interface Props {
  hightlightWord?: string[];
}

const Reader: React.FC<Props> = props => {
  const readerRootStore = useContext(ReaderContext);
  const { readerStore, readerUIStore } = readerRootStore!;
  const { dividePositions } = readerUIStore;
  const pageRefs: any = useRef([]);
  const swipeRef: MutableRefObject<any | null> = useRef(null);
  const readingSentence = untracked(() => readerStore.currentSentenceId);
  useEffect(() => {
    if (swipeRef.current?.$el) {
      swipeRef.current.update();
    }
    if (!readerUIStore.loaded.get()) return;
    if (readerUIStore.cutted.get()) return;
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
        pageTop = (
          lastItem.children[i - 1] || lastItem.children[i]
        ).getBoundingClientRect().bottom;
        cutPos[currentPage] = i;
        currentPage += 1;
      }
    }
    readerUIStore.dividePositions = cutPos;
    readerUIStore.cutted.set(true);
  });
  const rerenderTimer = useRef(-1);
  const rerender = useCallback(() => {
    rerenderTimer.current = setTimeout(() => {
      if ((readerUIStore.loaded as any).observers.size === 0) {
        rerender();
        return;
      }
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
      readerUIStore.loaded.set(true);
      console.log(readerUIStore.loaded, "loaded");
    }, 50);
  }, [readerUIStore]);

  useEffect(() => {
    rerender();
    return () => {
      clearTimeout(rerenderTimer.current);
    };
  }, []);

  useEffect(() => {
    const handler = () => {
      const page = swipeRef.current.activeIndex;
      if (page === 0) {
        if (!readerStore.atStart) {
          setTimeout(readerUIStore.prevSection, 0.1);
        }
      } else if (page === dividePositions.length + 2) {
        if (!readerStore.atEnd) {
          setTimeout(readerUIStore.nextSection, 0.1);
        }
      } else {
        untracked(() => {
          readerUIStore.changePage(swipeRef.current.activeIndex - 1);
        });
      }
    };

    if (swipeRef.current?.$el && readerUIStore.cutted.get()) {
      swipeRef.current.slideTo(
        readerUIStore.getPageBySentenceId(readingSentence) + 1,
        0
      );
      swipeRef.current.on("slideChange", handler);
      return () => {
        swipeRef.current.off("slideChange", handler);
      };
    }
  });

  useWindowSize(() => {
    console.log("clearWindow");
    readerUIStore.clearDivision();
    rerender();
  });

  useEffect(
    reaction(
      () => readerUIStore.fontSize,
      () => {
        readerUIStore.clearDivision();
        rerender();
      }
    ),
    []
  );

  const navigation = isPlatform("desktop")
    ? {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev"
      }
    : {};

  const params = {
    navigation: navigation,
    allowTouchMove: !isPlatform("desktop"),
    preventInteractionOnTransition: true,
    spaceBetween: 30
  };

  const pages = Array(dividePositions.length + 1)
    .fill(1)
    .map((_: any, i: number) => (
      <Page
        hightlightWord={props.hightlightWord}
        key={i}
        ref={node => {
          pageRefs.current[i] = node;
        }}
        sentences={readerUIStore.getPageSentences(i)}
      />
    ));

  return useObserver(() => {
    const loaded = readerUIStore.loaded.get();
    const cutted = readerUIStore.cutted.get();
    return (
      <Main font={readerUIStore.fontSize}>
        <Dict />
        <Cover enabled={loaded && cutted}>
          <IonSpinner name="crescent" />
        </Cover>
        <Swiper
          key={readerUIStore.dividePositions.length}
          {...params}
          getSwiper={node => {
            swipeRef.current = node;
          }}
        >
          {[<div key="start"></div>]
            .concat(pages)
            .concat([<div key="end"></div>])}
        </Swiper>
      </Main>
    );
  });
};

export default Reader;
