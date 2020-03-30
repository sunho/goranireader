import React, { useEffect, useState, useRef, useContext } from "react";
import { SelectedWord, DictSearchResult, DictWord } from "../../models";
import styled, { css } from "styled-components";
import { useOutsideClickObserver } from "../../utils/hooks";
import { instanceOf } from "prop-types";
import { ReaderContext } from "../../pages/ReaderPage";
import { IonCard, IonCardContent, IonList, IonItem, IonLabel, IonRow, IonCol, IonButton, IonIcon } from "@ionic/react";
import { caretForwardOutline, caretBackOutline } from 'ionicons/icons';

const Cover = styled.div`
  position: fixed;
  width: 100%;
  height: 100%;
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


const Content = styled(IonCardContent)`
  display: flex;
  flex-direction: column;
  height: 100%;
`;

const List = styled(IonList)`
  flex: 1 1;
  overflow-y: scroll;
`;

const DictWordComponent = styled.div`
  flex-shrink: 0;
  margin-bottom: .5em;
  padding-top: .5em;
  padding-left: .5em;
  padding-right: .5em;
  font-weight: 500;
  font-size: 1.5em;
`;

const WordSection = styled.div`
  display: flex;
`;

const WordSectionButton = styled.div`
  flex: 0 0 auto;
`;

const WordSectionText = styled.div`
  flex: 1;
  text-align: center;
`;


const DictButtons = styled.div`
  display: flex;
  flex-shrink: 0;
  padding-left: .5em;
  padding-right: .5em;
  padding-top: .5em;
  justify-content: space-between;
`;

const DictButton = styled.div<{ enabled: boolean }>`
  padding: .25em;
  background: #AB7756;
  font-weight: 700;
  color: white;
  ${props =>
    !props.enabled &&
    css`
      opacity: 0;
      pointer-events: none;
    `}
`;

interface Props {
  selectedWord: SelectedWord;
}

const Dict: React.FC<Props> = props => {
  const readerRootStore = useContext(ReaderContext);
  const { readerUIStore, rootStore } = readerRootStore;
  const { dictService } = rootStore;
  const [res, setRes] = useState<any[]>([]);
  const [pos, setPos] = useState(0);
  const dictRef = useRef<HTMLElement | null | undefined>(undefined);
  const { word, wordIndex, up, sentenceId } = props.selectedWord;

  useEffect(() => {
    setRes(dictService.find(word));
  }, [props]);

  useOutsideClickObserver(dictRef, () => {
    readerUIStore.cancelSelection();
  });

  const result = (resWord: DictWord) => {
    return (
      <>
        <WordSection>
          <WordSectionButton>
            <IonButton
              onClick={() => {
                setPos(pos - 1);
              }}
              disabled={pos === 0}
            >
              <IonIcon icon={caretBackOutline}></IonIcon>
            </IonButton>
          </WordSectionButton>
          <WordSectionText>
            <DictWordComponent>{resWord.word}</DictWordComponent>
          </WordSectionText>
          <WordSectionButton>
            <IonButton
              onClick={() => {
                setPos(pos + 1);
              }}
              disabled={pos === res.length - 1}
            >
              <IonIcon icon={caretForwardOutline}></IonIcon>
            </IonButton>
          </WordSectionButton>
        </WordSection>
        <List lines="full">
          {resWord.defs.map((def, i) => (
            <IonItem>
              <IonLabel className="ion-text-wrap">{def.def}
            </IonLabel>
          </IonItem>
          ))}
        </List>
      </>
    );
  };
  const notFound = <div>Not found</div>;
  return (
    <Cover>
      <Container hide={!res} ref={node => (dictRef.current = node)} up={up}>
        <Card>
          <Content>
            {res.length !== 0 && res[pos] ? result(res[pos]) : notFound}
          </Content>
        </Card>
      </Container>
    </Cover>
  );
};

export default Dict;
