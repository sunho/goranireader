import { makeStyles } from "@material-ui/core";

export const useCommonStyle = makeStyles(theme => ({
  container: {
    paddingTop: theme.spacing(4),
    paddingBottom: theme.spacing(4)
  },
  paper: {
    padding: theme.spacing(2),
    display: "flex",
    overflow: "auto",
    flexDirection: "column"
  },
  header: {
    marginBottom: theme.spacing(2)
  }
}));
