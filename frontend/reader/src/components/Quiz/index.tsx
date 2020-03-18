import React, { useState, useEffect, useRef, MutableRefObject } from "react";
import styled, { css } from "styled-components";
import { Question } from "../../model";
import { pat } from "../SwipeItemChildren";

const Main = styled.div`
  height: calc(100vh - 20px);
  padding: 10px 10px;
  width: calc(100% - 20px);
  font-family: 'Noto Sans KR', sans-serif;
  font-size: 17px;
`;

const QuestionComponent = styled.div`
  margin-top: 20px;
`;

const SentenceComponent = styled.div`
  margin-top: 10px;
  background: lightgray;
  padding: 10px;
  font-family: 'Lora', serif;
  -webkit-overflow-scrolling: touch;
  overflow: scroll;
`;

y`;

const OptionComponent = styled.div<{selected: boolean}>`
  margin-top: 10px;
  padding: 10px;
  background: #f5c3a4;

  ${props => (
    props.selected && css`
      background: #bf9478;
    `
  )}
`;

const OptionContainer = styled.div`
  margin-top: auto;
`;

const NextButton = styled.div<{selected: boolean}>`
  padding: 10px 20px;
  display: inline-block;
  background: #AB7756;
  opacity: 0;
  color: white;

  ${props => (
    props.selected && css`
      opacity: 1;
    `
  )}
`;

const ButtonContainer = styled.div`
  margin-top: 50px;
  display: flex;
  justify-content: flex-end;
  margin-bottom: 20px;
`;

const Container = styled.div`
  display: flex;
  flex-direction: column;
  height: 100%;
`;


interface Props {
  questions: Question[];
  readingQuestion: string;
}

const Quiz: React.FC<Props> = (props: Props) => {
  const { questions } = props;
  const [readingQuestion, setReadingQuestion] = useState<string>(props.readingQuestion);
  const [answer, setAnswer] = useState<number | null>(null);
  const _i = questions.findIndex(o => o.id === readingQuestion);
  const i = _i === -1 ? 0 : _i;
  const question = questions[i];
  useEffect(() => {
    window.app.setLoading(false);
  }, []);

  const submit = () => {
    if (answer == null) return;
    window.app.submitQuestion(readingQuestion, question.options[answer], answer === question.answer);
    if (i === questions.length - 1) {
      window.app.endQuiz();
    } else {
      const newReadingQuestion = questions[i+1].id;
      window.app.setReadingQuestion(newReadingQuestion)
      setReadingQuestion(newReadingQuestion);
      setAnswer(null);
    }
  }

  return (
    <Main>
        {question.type === 'word' && (
          <Container>
            <QuestionComponent>
              Choose the definition of highlighted word in this paragraph.
            </QuestionComponent>
            <SentenceComponent>
              {question.sentence.split(pat).filter(w => w.length !== 0).map((word, i) => {
                return <WordComponent selected={Math.floor(i/2) === question.wordIndex && !word.match(pat) }>{word}</WordComponent>;
              })}
            </SentenceComponent>
            <OptionContainer>
              {
                question.options.map((option, j) => (
                  <OptionComponent onClick={() => {
                    setAnswer(j);
                  }} key={j} selected={answer === j}>
                    {option}
                  </OptionComponent>
                ))
              }
            </OptionContainer>
            <ButtonContainer>
              <NextButton onClick={() => {submit()}} selected={answer !== null}>Next</NextButton>
            </ButtonContainer>
          </Container>
        )}
        {question.type === 'summary' && (
          <Container>
            <QuestionComponent>
              Choose the most accurate summary of the last chapter.
            </QuestionComponent>
            <OptionContainer>
              {
                question.options.map((option, j) => (
                  <OptionComponent onClick={() => {
                    setAnswer(j);
                  }} key={j} selected={answer === j}>
                    {option}
                  </OptionComponent>
                ))
              }
            </OptionContainer>
            <ButtonContainer>
              <NextButton onClick={() => {submit()}} selected={answer !== null}>Next</NextButton>
            </ButtonContainer>
          </Container>
        )}
    </Main>
  );
};

export default Quiz;
