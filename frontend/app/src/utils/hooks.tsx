
import React, { useLayoutEffect, useState } from 'react';

import { MutableRefObject, useEffect } from "react";
import { LiteEvent } from "./event";
import { isPlatform } from '@ionic/react';

export function useOutsideClickObserver(
  ref: MutableRefObject<HTMLElement | null | undefined>,
  callback: () => void
) {
  function handleClickOutside(event: any) {
    if (ref.current && !ref.current.contains(event.target)) {
      callback();
    }
  }

  useEffect(() => {
    if (isPlatform('electron')) {
      document.addEventListener("mousedown", handleClickOutside);
      return () => {
        document.removeEventListener("mousedown", handleClickOutside);
      };
    } else {
      document.addEventListener("touchstart", handleClickOutside);
      return () => {
        document.removeEventListener("touchstart", handleClickOutside);
      };
    }
  });
}

export function useLiteEventObserver<T>(
  event: LiteEvent<T>,
  callback: (v?: T) => void,
  deps: any
) {
  function handleEvent(v?: T) {
    callback(v)
  }

  useEffect(() => {
    event.on(handleEvent);
    return () => {
      event.off(handleEvent);
    }
  }, deps);
}

export function useWindowSize(event: () => void) {
  const [size, setSize] = useState([0, 0]);
  useLayoutEffect(() => {
    function updateSize() {
      event();
    }
    window.addEventListener('resize', updateSize);
    updateSize();
    return () => window.removeEventListener('resize', updateSize);
  }, []);
  return size;
}
