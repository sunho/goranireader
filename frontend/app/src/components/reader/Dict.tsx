import React, { useEffect, useState, useRef, useContext } from "react";
import { SelectedWord, DictSearchResult, DictWord } from "../../models";
import styled, { css } from "styled-components";
import { useOutsideClickObserver } from "../../utils/hooks";
import { instanceOf } from "prop-types";
import { ReaderContext } from "../../pages/ReaderPage";

const DictContainer2 = styled.div`
  position: fixed;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
`;

const DictContainer = styled.div<{ up: boolean; hide: boolean }>`
  font-family: 'Noto Sans KR', sans-serif;
  font-size: .8em;
  position: absolute;
  ${props =>
    props.up
      ? css`
          top: 10px;
        `
      : css`
          bottom: 10px;
        `}
  ${props =>
    props.hide &&
    css`
      visibility: none;
    `}
  background: white;
  height: calc(40%);
  width: calc(100% - 40px);
  max-width: 500px;
  display: flex;
  flex-direction: column;
  box-shadow: 0 19px 38px rgba(0, 0, 0, 0.3), 0 15px 12px rgba(0, 0, 0, 0.22);
  margin-left: 20px;
  z-index: 999;
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

const DictDefsComponent = styled.div`
  margin-top: .25em;
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
  font-weight: 400;
  & > div {
    background: lightgray;
    padding: .5em;
    margin-bottom: .5em;
    margin-left: .5em;
    margin-right: .5em;
    border-radius: .5em;
    &:active {
      background: gray;
    }
  }
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
        {res.length !== 1 && (
          <DictButtons>
            <DictButton
              onClick={() => {
                setPos(pos - 1);
              }}
              enabled={pos !== 0}
            >
              prev
            </DictButton>
            <DictButton
              onClick={() => {
                setPos(pos + 1);
              }}
              enabled={pos !== res.length - 1}
            >
              next
            </DictButton>
          </DictButtons>
        )}
        <DictWordComponent>{resWord.word}</DictWordComponent>
        <DictDefsComponent>
          {resWord.defs.map((def, i) => (
            <div key={i} onClick={() => {
              // window.app.addUnknownWord(sentenceId, wordIndex, resWord.word, def.def);
              // window.webapp.cancelSelect();
            }}>{def.def}</div>
          ))}
        </DictDefsComponent>
      </>
    );
  };
  const notFound = <div>Not found</div>;
  return (
    <DictContainer2>
    <DictContainer hide={!res} ref={node => (dictRef.current = node)} up={up}>
      {res.length !== 0 && res[pos] ? result(res[pos]) : notFound}
    </DictContainer>
    </DictContainer2>
  );
};

export default Dict;
