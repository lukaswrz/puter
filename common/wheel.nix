{ config, ... }:
{
  users.groups.wheel.members = config.users.normalUsers;
}
