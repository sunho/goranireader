import { MutableRefObject, useEffect } from "react";
import { LiteEvent } from "./event";

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
    document.addEventListener("touchstart", handleClickOutside);
    return () => {
      document.removeEventListener("touchstart", handleClickOutside);
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
