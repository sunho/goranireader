import React, { useEffect, useState, useRef } from "react";
import { SelectedWord, DictSearchResult, DictWord } from "../../model";
import styled, { css } from "styled-components";
import { useOutsideClickObserver } from "../../utills/hooks";

const DictContainer = styled.div<{ up: boolean; hide: boolean }>`
  position: fixed;
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
  display: flex;
  flex-direction: column;
  box-shadow: 0 19px 38px rgba(0, 0, 0, 0.3), 0 15px 12px rgba(0, 0, 0, 0.22);
  margin-left: 20px;
  z-index: 999;
`;

const DictWordComponent = styled.div`
  flex-shrink: 0;
  margin-bottom: 15px;
  padding-top: 15px;
  padding-left: 10px;
  padding-right: 10px;
  font-weight: 500;
  font-size: 15pt;
`;

const DictDefsComponent = styled.div`
  margin-top: 5px;
  overflow-y: auto;
  & > div {
    background: lightgray;
    padding: 10px;
    margin-bottom: 10px;
    margin-left: 10px;
    margin-right: 10px;
    border-radius: 10px;
    &:active {
      background: gray;
    }
  }
`;

const DictButtons = styled.div`
  display: flex;
  flex-shrink: 0;
  padding-left: 10px;
  padding-right: 10px;
  padding-top: 10px;
  justify-content: space-between;
`;

const DictButton = styled.div<{ enabled: boolean }>`
  padding: 7px;
  background: gray;
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
  const [res, setRes] = useState<DictSearchResult | undefined>(undefined);
  const [pos, setPos] = useState(0);
  const dictRef = useRef<HTMLElement | null | undefined>(undefined);
  const { word, wordIndex, up, sentenceId } = props.selectedWord;

  useEffect(() => {
    const out: DictSearchResult = JSON.parse(window.app.dictSearch(word));
    setRes(out);
  }, [props]);

  useOutsideClickObserver(dictRef, () => {
    window.webapp.cancelSelect();
  });

  const result = (resWord: DictWord) => {
    return (
      <>
        {res!.words.length !== 1 && (
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
              enabled={pos !== res!.words.length - 1}
            >
              next
            </DictButton>
          </DictButtons>
        )}
        <DictWordComponent>{resWord.word}</DictWordComponent>
        <DictDefsComponent>
          {resWord.defs.map((def, i) => (
            <div key={i} onClick={() => {
              window.app.addUnknownWord(sentenceId, wordIndex, resWord.word, def.def);
              window.webapp.cancelSelect();
            }}>{def.def}</div>
          ))}
        </DictDefsComponent>
      </>
    );
  };
  const notFound = <div>Not found</div>;
  return (
    <DictContainer hide={!res} ref={node => (dictRef.current = node)} up={up}>
      {res && res.words[pos] ? result(res.words[pos]) : notFound}
    </DictContainer>
  );
};

export default Dict;
