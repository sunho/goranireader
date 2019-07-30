import React from 'react'
import styles from './index.module.scss'
import { Class } from '../../models';
import { useFetch } from '../../hooks/fetch';
import { getClasses } from '../../api';
import Select from '../Select';

interface Props {
  setClass: (clas: Class) => void
}

const Header: React.SFC<Props> = (props) => {
  const [clases, _] = useFetch(getClasses(), [])
  return (
    <div className={styles.Header}>
      <div className={styles.HeaderClass}>
        <div className={styles.HeaderClassLabel}>Class:</div>
        <Select options={clases.map((clas) => ({name: clas.name, item: clas}))}
                change={(item) => {props.setClass(item)}}/>
      </div>
    </div>
  )
}

export default Header
