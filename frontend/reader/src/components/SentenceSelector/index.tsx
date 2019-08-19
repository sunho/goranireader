import React, { useRef } from "react";
import { SelectedSentence } from "../../model";
import styled, { css } from "styled-components";
import { useOutsideClickObserver } from "../../utills/hooks";

const SentenceSelectorContainer = styled.div<{  bottom: number; top: number; up: boolean;}>`
  display: flex;
  position: fixed;
  ${props => {
    if (props.up) {
      return css`
        top: ${props.top - 36}px;
      `;
    } else {
      return css`
        top: ${props.bottom}px;
      `;
    }
  }}

  & > div {
    background: gray;
    color: white;
  }
  z-index: 999;
`;

interface Props {
  selectedSentence: SelectedSentence;
}

const SentenceSelector: React.FC<Props> = props => {
  const conRef = useRef<HTMLElement | undefined | null>(undefined);
  useOutsideClickObserver(conRef, () => {
    window.webapp.cancelSelect();
  });

  return (
    <SentenceSelectorContainer
      ref={node => {
        conRef.current = node;
      }}
      up={props.selectedSentence.up}
      top={props.selectedSentence.top}
      bottom={props.selectedSentence.bottom}
    >
      <div onClick={() => {
        window.app.addUnknownSentence(props.selectedSentence.sentenceId);
        window.webapp.cancelSelect();
      }}>I have no idea!</div>
    </SentenceSelectorContainer>
  );
};

export default SentenceSelector;
