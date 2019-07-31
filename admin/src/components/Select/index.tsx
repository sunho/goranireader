import React, { useState, useEffect } from 'react'
import styles from './index.module.scss'

export interface SelectOption {
  name: string
  item: any
}

interface Props {
  options: SelectOption[]
  change: (item: any) => void
}

const Select: React.SFC<Props> = (props) => {
  const [value, setValue] = useState("-1")
  return (
    <div className={styles.Select}>
      <select value={value} onChange={(e) => {
        if (e.target.value == "-1") return;
        const i = parseInt(e.target.value)
        setValue(e.target.value)
        props.change(props.options[i].item)
      }}>
        <option key={-1} value="-1"></option>
        {
          props.options.map((option, i) => (
            <option key={i} value={i.toString()}>{option.name}</option>
          ))
        }
      </select>
    </div>
  )
}

export default Select

