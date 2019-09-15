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
import { withFirebase } from "../Firebase";

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

const SignUpPage: React.FC<any> = props => {
  const classes = useStyles();
  const handleInputChange = (e: any) => {
    const { name, value } = e.target;
    setValues({ ...values, [name]: value });
  };

  const addUser = (e: any) => {
    e.preventDefault();
    const { email, password } = values;
    if (!email || !password) return;
    props.firebase
      .doCreateUserWithEmailAndPassword(email, password)
      .then(() => {
        props.history.push("/");
      })
      .catch((err: any) => {
        alert(err.message);
      });
  };

  const [values, setValues] = useState({ email: "", password: "" });
  return (
    <Container component="main" maxWidth="xs">
      <CssBaseline />
      <Paper className={classes.paper}>
        <Typography component="h1" variant="h6" color="inherit" noWrap>
          Gorani Reader Admin Sign Up
        </Typography>
        <form onSubmit={addUser} className={classes.form}>
          <TextField
            variant="outlined"
            margin="normal"
            required
            fullWidth
            id="email"
            label="Email Address"
            name="email"
            autoComplete="email"
            autoFocus
            value={values.email}
            onChange={handleInputChange}
          />
          <TextField
            variant="outlined"
            margin="normal"
            required
            fullWidth
            name="password"
            label="Password"
            type="password"
            id="password"
            autoComplete="current-password"
            value={values.password}
            onChange={handleInputChange}
          />
          <Button
            type="submit"
            fullWidth
            variant="contained"
            color="primary"
            className={classes.submit}
          >
            Sign Up
          </Button>
        </form>
      </Paper>
    </Container>
  );
};

export default withFirebase(SignUpPage);
