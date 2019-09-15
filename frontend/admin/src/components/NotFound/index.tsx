import React, { useState } from "react";
import {
  TextField,
  Button,
  makeStyles,
  Container,
  CssBaseline,
  Typography,
  Paper
} from "@material-ui/core";
import { Link } from "react-router-dom";

const useStyles = makeStyles(theme => ({
  "@global": {
    body: {
      backgroundColor: theme.palette.common.white
    }
  },
  paper: {
    marginTop: theme.spacing(8),
    padding: theme.spacing(6),
    display: "flex",
    flexDirection: "column",
    alignItems: "center"
  },
  avatar: {
    margin: theme.spacing(1),
    backgroundColor: theme.palette.secondary.main
  },
  form: {
    width: "100%", // Fix IE 11 issue.
    marginTop: theme.spacing(1)
  },
  submit: {
    margin: theme.spacing(3, 0, 2)
  }
}));

const NotFound: React.FC = props => {
  const classes = useStyles();
  const [values, setValues] = useState({ email: "", password: "" });
  return (
    <Container component="main" maxWidth="xs">
      <CssBaseline />
      <Paper className={classes.paper}>
        <Typography component="h1" variant="h6" color="inherit">
          Page not found
        </Typography>
        <Link to="/dashboard" style={{ textDecoration: 'none' }}>
          <Button
            style={{marginTop: "20px"}}
            variant="contained"
            color="primary"
          >
            GO TO MAIN PAGE
          </Button>
        </Link>
      </Paper>
    </Container>
  );
};

export default NotFound;
