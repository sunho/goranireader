import React, { ReactNode } from 'react'
import {
    Container,
    Divider,
    Dropdown,
    Grid,
    Icon,
    Image,
    List,
    Menu,
    Segment,
    Visibility,
} from 'semantic-ui-react'
import { Link } from 'gatsby'
import { Location, WindowLocation } from '@reach/router'

interface MenuItemProps { 
    name: string
    path: string
}

const MenuItem: React.SFC<MenuItemProps> = ({name, path}) => (
    <Location>
        {({ location }) => (
            <Link to={path}><Menu.Item name={name} active={location.pathname === path}/></Link>
        )}
    </Location>
)

const Sidebar: React.SFC = () => (
    <div>
        <Menu fluid vertical tabular>
            <MenuItem name='학생' path='/student'/>
            <MenuItem name='과제' path='/mission'/>
        </Menu>
    </div>
)

export default Sidebar
