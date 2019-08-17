import { MutableRefObject, useEffect } from "react";
import { LiteEvent } from "./event";

export function useOutsideClickObserver(
  ref: MutableRefObject<HTMLElement | undefined>,
  callback: () => void
) {
  function handleClickOutside(event: any) {
    if (ref.current && !ref.current.contains(event.target)) {
      callback();
    }
  }

  useEffect(() => {
    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
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
