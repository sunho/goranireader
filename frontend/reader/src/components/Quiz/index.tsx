import React, { useState, useEffect, useRef, MutableRefObject } from "react";
import styled, { css } from "styled-components";
import { Question } from "../../model";

const Main = styled.div`
  height: calc(100vh - 20px);
  padding: 10px 5px;
  width: calc(100% - 10px);
`;

interface Props {
  questions: Question[];
  readingQuestion: string;
}

const Quiz: React.FC<Props> = (props: Props) => {
  const { questions, readingQuestion } = props;
  const i = questions.findIndex(o => o.id === readingQuestion) || 0;

  return (
    <Main>
    </Main>
  );
};

export default Quiz;
