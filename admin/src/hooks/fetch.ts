import { useState, useEffect } from "react";

export function useFetch<T>(promise: Promise<T>, initial: T): [T, boolean] {
  const [data, setData] = useState(initial);
  const [loading, setLoading] = useState(true);
  async function fetchUrl() {
    let data = await promise
    setData(data);
    setLoading(false);
  }
  useEffect(() => {
    fetchUrl();
  }, []);
  return [data, loading];
}
