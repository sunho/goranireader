import React, { useState, useEffect } from 'react';
import logo from './logo.svg';
import ReactSwipe from 'react-swipe';
import './App.css';



const App: React.FC = () => {
  const data = Array(100).fill("hEllo erasdfasf asdfsadfasfasf asdf asfasf");

  let dummy: Element;
  let reactSwipeEl: ReactSwipe;
  const [min, setMin] = useState(3);
  const [items, setItems]: [Element[], any] = useState([]);
  useEffect(() => {
    setItems(makePages());
  }, []); 
  const makePage = (start: number): number => {
    const targetHeight = window.innerHeight - 40;
    let tmp = "";
    for (let i = start; i < data.length; i++) {
      const tmp2 = tmp + "<div>" + data[i].split(" ").map((it: string) => "<span>" + it + " </span>").join("") + "</div>";
      dummy.innerHTML = tmp2;
      if (dummy.clientHeight > targetHeight) {
        return (i - 1);
      }
      tmp = tmp2;
    }
    return data.length;
  };
  const makePages = () => {
    let end = 0;
    let out: any[] = [];
    while (end < data.length) {
      const newEnd = makePage(end);
      out.push(<div>{
        data.slice(end, newEnd).map(sen => {
        return (<div>{sen.split(" ").map((word: string) => <span onClick={(e)=>{console.log((e.target as any).innerText)}}>{word+" "}</span>)}</div>);
      })
      }
      </div>);
      end = newEnd;
    }
    return out;
  }
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
          childCount={items.length}
          ref={el => (reactSwipeEl = el!)}
        >
        {items}
      </ReactSwipe>
      <div
        className="Dummy"
        ref={el => (dummy = el!)}
      />
    </div>
    
  );
}



export default App;
