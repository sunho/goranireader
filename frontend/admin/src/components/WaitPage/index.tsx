import React, { useState, useContext } from "react";
import {
  TextField,
  Button,
  makeStyles,
  Container,
  CssBaseline,
  Typography,
  Paper
} from "@material-ui/core";

import {FirebaseContext} from '../Firebase';

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

const WaitPage: React.FC = props => {
  const classes = useStyles();
  const handleInputChange = (e: any) => {
    const { name, value } = e.target;
    setValues({ ...values, [name]: value });
  };

  const addItem = () => {
    const { email, password } = values;

    if (!email || !password) return;
  };

  const firebase = useContext(FirebaseContext)!;
  const [values, setValues] = useState({ email: "", password: "" });
  return (
    <Container component="main" maxWidth="xs">
      <CssBaseline />
      <Paper className={classes.paper}>
        <Typography component="h1" variant="h6" color="inherit">
            Your account is not verified yet. Please contact to ksunhokim123@naver.com
        </Typography>
        <Button
          variant="contained"
          style={{marginTop: "20px"}}
          color="primary"
          onClick={() => {
            firebase.auth.signOut().then(() => {
              window.location.href="/login";
            });
          }}
        >
          LOGOUT
        </Button>
      </Paper>
    </Container>
  );
};

export default WaitPage;
