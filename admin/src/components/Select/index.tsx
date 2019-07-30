import React, { useState } from 'react'
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
  const [value, setValue] = useState("")
  return (
    <div className={styles.Select}>
      <select value={value} onChange={(e) => {
        const i = parseInt(e.target.value)
        setValue(e.target.value)
        props.change(props.options[i].item)
      }}>
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

