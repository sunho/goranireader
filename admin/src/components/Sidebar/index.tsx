import React from 'react'
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

const Sidebar: React.SFC = () => (
    <div>
        <Menu fluid vertical tabular>
            <Menu.Item name='학생'/>
            <Menu.Item name='과제'/>
        </Menu>
    </div>
)

export default Sidebar
