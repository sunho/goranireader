import React, { useEffect, useState, useRef, useContext } from "react";
import { SelectedWord, DictSearchResult, DictWord } from "../../core/models";
import styled, { css } from "styled-components";
import { useOutsideClickObserver } from "../../core/utils/hooks";
import { instanceOf } from "prop-types";
import { IonCard, IonCardContent, IonList, IonItem, IonLabel, IonRow, IonCol, IonButton, IonIcon } from "@ionic/react";
import { caretForwardOutline, caretBackOutline } from 'ionicons/icons';
import { ReaderContext } from "../stores/ReaderRootStore";
import DictResultList from "./DictResultList";
import { autorun } from "mobx";
import { useObserver } from "mobx-react";

const Cover = styled.div`
  position: fixed;
  left: 0;
  top: 0;
  right: 0;
  bottom :0;
  z-index: 54;
  display: flex;
  justify-content: center;
`;


const Container = styled.div<{ up: boolean; hide: boolean }>`
  font-family: 'Noto Sans KR', sans-serif;
  font-size: 14px;
  position: absolute;
  ${props =>
    props.up
      ? css`
          top: 0px;
        `
      : css`
          bottom: 30px;
        `}
  ${props =>
    props.hide &&
    css`
      visibility: none;
    `}
  height: calc(50%);
  max-height: 300px;
  width: 100%;
  left: 0;
  display: flex;
  justify-content: center;
  z-index: 999;
`;

const Card = styled(IonCard)`
  width: calc(100% - 40px);
  max-width: 500px;
  height: 100%;
`;

const Dict: React.FC = () => {
  const readerRootStore = useContext(ReaderContext);
  const { readerUIStore, rootStore } = readerRootStore;
  const { dictService } = rootStore;
  const [res, setRes] = useState<any[]>([]);
  const dictRef = useRef<HTMLElement | null | undefined>(undefined);

  useEffect(
    () =>
    autorun(() => {
      if (readerUIStore.selectedWord) {
        setRes(dictService.find(readerUIStore.selectedWord.word));
      }
    }
 ),[]);

  useOutsideClickObserver(dictRef, () => {
    readerUIStore.selectedWord = undefined;
  });

  const notFound = <div>Not found</div>;
  return useObserver(() => (
    <>
    {
      readerUIStore.selectedWord &&
      <Cover>
        <Container hide={!res} ref={node => (dictRef.current = node)} up={readerUIStore.selectedWord.up}>
          <Card>
            {res.length !== 0 ? <DictResultList res={res}/> : notFound}
          </Card>
        </Container>
      </Cover>
      }
    </>
  ));
};

export default Dict;
