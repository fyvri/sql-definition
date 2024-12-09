@startumlz

!theme mars
title "Customer Relationship Management Service ERD"

class Actor {
    + id : bigint unsigned
    + username : varchar
    + password : varchar
    + role_id : int unsigned
    + is_verified : enum('true', 'false')
    + is_active : enum('true', 'false')
    + created_at : timestamp
    + updated_at : timestamp
    --
    + role() : Role
}

class Role {
    + id : int unsigned
    + name : varchar
}

class RegisterApproval {
    + id : bigint unsigned
    + admin_id : bigint unsigned
    + super_admin_id : bigint unsigned
    + status : varchar
    --
    + admin() : Actor
    + superAdmin() : Actor
}

class Customer {
    + id : bigint unsigned
    + first_name : varchar
    + last_name : varchar
    + email : varchar
    + avatar : varchar
    + created_at : timestamp
    + updated_at : timestamp
    --
    + syncData()
}

class ExternalAPI implements Customer {
}

Actor "1" --> "1" Role
Actor "1" --> "1" RegisterApproval : Admin Requests Approval
RegisterApproval "1" --> "1" Actor : Approved By Super Admin

@enduml