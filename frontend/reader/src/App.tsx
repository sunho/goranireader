import React, { useState, useEffect, useRef } from 'react';
import logo from './logo.svg';
import ReactSwipe from 'react-swipe';
import './App.css';

// thanks to  https://github.com/yoo2001818
const App: React.FC = () => {
  const data = Array(200).fill("hEllo erasdfasf asdfsadfasfasf asdf asfasf ㅁㄴㄹㅇ ㅁㄴㅇㄹㅁㄴㅇㄹ ㅁㄴㄹㄴㅁㅇㄹㅁㄴ ㄹㄴㅁㅇㄹㅁㄴ ㄹㅁㄴㅇㄹ ㅁㄴㅇㄹ ㅁㄴㄹㄴㅁ ㄹㅁ ");
  const [dividePositions, setDividePositions]: [any, any] = useState([]);
  const swipeItemRefs: any = useRef([]);
  useEffect(() => {
    // 마지막 페이지의 자를 노드 위치 계산
    const lastItem = swipeItemRefs.current[dividePositions.length];
    const parentBounds = lastItem.getBoundingClientRect();
    const parentTop = parentBounds.top;
    const parentHeight = parentBounds.height;
    const prevPos = (dividePositions[dividePositions.length - 1] || 0);
    let pageTop = parentTop;
    let currentPage = 0;
    let cutPos: any = [];
    // HTMLElement.children은 놀랍게도 배열이 아니라서 findIndex같은걸 못써요 ㅠㅠ
    for (let i = 0; i < lastItem.children.length; i += 1) {
      const childNode = lastItem.children[i];
      const childBounds = childNode.getBoundingClientRect();
      const offset = childBounds.bottom - pageTop;
      if (offset >= parentHeight) {
        pageTop = lastItem.children[i - 1].getBoundingClientRect().bottom;
        // 노드 위치는 dividePositions의 마지막 값만큼 뒤로 가있기 때문에 앞으로 다시
        // 밀어주는 작업이 필요함
        cutPos[currentPage] = i + prevPos;
        currentPage += 1;
      }
    }
    // 자를게 있다면 절단
    if (cutPos.length > 0) {
      setDividePositions((prevState: any) => [
        ...prevState,
        ...cutPos,
      ]);
    }
  }, [dividePositions]);
  useEffect(() => {
    function handleResize() {
      setDividePositions([]); 
    }
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);
  
  const swipeOptions = {
    startSlide: 0,
    continuous: false,
    callback: () => {
    }
  };
  return (
    <div className="App">
      <ReactSwipe
        className="Swipe"
        swipeOptions={swipeOptions}
        childCount={dividePositions.length + 1}
      >
        { [...dividePositions, Infinity].map((endPos, i) => (
          <div
            className="SwipeItem"
            key={i}
            ref={(node) => swipeItemRefs.current[i] = node}
          >
            { data.slice(dividePositions[i - 1] || 0, endPos)
              .map((paragraph, i) => (
                <p key={i}>
                  { paragraph.split(" ").map((word: any, i: any) => (
                    <span key={i} onClick={() => alert(word)}>
                      { word + ' ' }
                    </span>
                  ))}
                </p>
              ))
            }
          </div>
        )) }
      </ReactSwipe>
    </div>
  );
}


export default App;
