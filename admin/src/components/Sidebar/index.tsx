import React, { ReactNode } from 'react'
import { Link } from 'gatsby'
import { Location, WindowLocation } from '@reach/router'

interface MenuItemProps {
  name: string
  path: string
}

//location.pathname === path

const MenuItem: React.SFC<MenuItemProps> = ({name, path}) => (
  <Location>
    {({ location }) => (
      <Link to={path}><div>{name}</div></Link>
    )}
  </Location>
)

const Sidebar: React.SFC = () => (
  <div>
    <MenuItem name='학생' path='/student'/>
    <MenuItem name='과제' path='/mission'/>
  </div>
)

export default Sidebar
