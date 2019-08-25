import React from 'react';
import { AdminUser, Class } from '../../model';

const AuthUserContext = React.createContext<AdminUser | null>(null);

export default AuthUserContext;