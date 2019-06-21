import { useState } from "react";

export const useInput = initialValue => {
  const [value, setValue] = useState(initialValue);

  return {
    value,
    setValue,
    reset: () => setValue(""),
    bind: {
      value,
      onChange: (event, obj) => {
        if (obj) {
            setValue(obj.value);
        } else {
            setValue(event.target.value);
        }
      }
    }
  };
};