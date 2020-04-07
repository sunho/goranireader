import { DictWord } from "../../core/models";
import React from "react";
import styled from "styled-components";
import {
  IonCardContent,
  IonList,
  IonButton,
  IonIcon,
  IonItem,
  IonLabel
} from "@ionic/react";
import { caretBackOutline, caretForwardOutline } from "ionicons/icons";
import { useState } from "react";
import ErrorBoundary from "../../core/components/ErrorBoundary";

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
  margin-bottom: 0.5em;
  padding-top: 0.5em;
  padding-left: 0.5em;
  padding-right: 0.5em;
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

interface Props {
  res: DictWord[];
}

const DictResultList: React.FC<Props> = props => {
  const [pos, setPos] = useState(0);
  const resWord = props.res[pos];
  const { res } = props;
  return (
    <>
      {resWord && (
        <Content>
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
              <IonItem key={i}>
                <IonLabel className="ion-text-wrap">{def.def}</IonLabel>
              </IonItem>
            ))}
          </List>
        </Content>
      )}
    </>
  );
};

export default DictResultList;
