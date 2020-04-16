import {app, logger} from './index';

const port = 8080;
app.listen(port, () => logger.info(`apiserver listening on ${port}`));
