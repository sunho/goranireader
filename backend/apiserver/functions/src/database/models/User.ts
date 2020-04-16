import Sequelize from 'sequelize';
import sequelize from '../index';

class User extends Sequelize.Model<User> {
    public email!: string;

    public nickname!: string;

    public readonly createdAt!: Date;

    public readonly updatedAt!: Date;
}

User.init(
    {
        email: {
            type: Sequelize.STRING,
            allowNull: false,
            unique: true,
            primaryKey: true
        },
        nickname: {
            type: Sequelize.STRING,
            allowNull: true
        }
    },
    { sequelize, modelName: 'user', timestamps: true }
);

export default User;
