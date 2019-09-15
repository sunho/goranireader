import React, { useContext } from "react";
import ListItem from "@material-ui/core/ListItem";
import ListItemIcon from "@material-ui/core/ListItemIcon";
import ListItemText from "@material-ui/core/ListItemText";
import DashboardIcon from "@material-ui/icons/Dashboard";
import PeopleIcon from "@material-ui/icons/People";
import ProgressIcon from "@material-ui/icons/Timeline";
import BarChartIcon from "@material-ui/icons/BarChart";
import { Link } from "react-router-dom";
import { ClasssContext } from "../Auth/withClass";
import { Divider, makeStyles } from "@material-ui/core";
import { FirebaseContext } from "../Firebase";

const useStyles = makeStyles(theme => ({
  appBarSpacer: {
    paddingTop: theme.spacing(2),
    paddingBottom: theme.spacing(2)
  }
}));

const MainListItems: React.FC = props => {
  const classes = useStyles();
  const firebase = useContext(FirebaseContext)!;
  const classInfo = useContext(ClasssContext)!;
  return (
    <div>
      <ListItem>
        <ListItemText primary="Class" />
      </ListItem>

      {classInfo.classes.map(clas => (
        <ListItem
          key={clas.id}
          button
          onClick={() => {classInfo.setId(clas.id)}}
          {...{ to: `${window.location.pathname}?class=${clas.id}` }}
          component={Link}
          selected={classInfo.currentId === clas.id}
        >
          <ListItemText primary={clas.name} />
        </ListItem>
      ))}
      <div className={classes.appBarSpacer} />
      <Divider />
      <ListItem
        {...{ to: `/dashboard/${window.location.search}` }}
        component={Link}
        selected={window.location.pathname === "/dashboard/" || window.location.pathname === '/dashboard'}
        button
      >
        <ListItemIcon>
          <PeopleIcon />
        </ListItemIcon>
        <ListItemText primary="Student" />
      </ListItem>
      <ListItem
        button
        {...{ to: `/dashboard/mission${window.location.search}` }}
        component={Link}
        selected={window.location.pathname === "/dashboard/mission"}
      >
        <ListItemIcon>
          <DashboardIcon />
        </ListItemIcon>
        <ListItemText primary="Mission" />
      </ListItem>
      <ListItem
        button
        {...{ to: `/dashboard/progress${window.location.search}` }}
        component={Link}
        selected={window.location.pathname === "/dashboard/progress"}
      >
        <ListItemIcon>
          <ProgressIcon />
        </ListItemIcon>
        <ListItemText primary="Progress" />
      </ListItem>
      <ListItem
        button
        {...{ to: `/dashboard/report${window.location.search}` }}
        component={Link}
        selected={window.location.pathname === "/dashboard/report"}
      >
        <ListItemIcon>
          <BarChartIcon />
        </ListItemIcon>
        <ListItemText primary="Report" />
      </ListItem>

      <div className={classes.appBarSpacer} />
      <Divider />

      <ListItem
        button
        onClick={() => {
          firebase.auth.signOut().then(() => {
            window.location.href="/login";
          });
        }}
      >
        <ListItemText primary="Logout" />
      </ListItem>
    </div>
  );
};

export default MainListItems;
