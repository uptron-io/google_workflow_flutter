insert into auth.users ("id", "instance_id", "aud", "role", "email", "confirmation_token", "recovery_token", "email_change", "encrypted_password", "raw_app_meta_data", "raw_user_meta_data", "created_at", "email_confirmed_at", "updated_at", "email_change_token_new")
values 
('3243e656-f55d-4811-93d6-f1a1c06cbb96', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'user@demo.kz', '', '', '', '$2a$10$v4tObauuLaBQ0032C.04M.K224SjQwobie8fEewwqiuNUCxFnB84u', '{"provider":"email","providers":["email"], "instance_id":["demo"],"data_area_id":["demo_org_a","demo_org_b"]}', '{}', NOW(), NOW(), NOW(), ''),
('3243e656-f55d-4811-93d6-f1a1c06cbb97', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'admin@demo.kz', '', '', '', '$2a$10$v4tObauuLaBQ0032C.04M.K224SjQwobie8fEewwqiuNUCxFnB84u', '{"provider":"email","providers":["email"], "instance_id":["demo"],"data_area_id":["demo_shared","demo_org_a","demo_org_b"]}', '{}', NOW(), NOW(), NOW(), '');

insert into public.process ("name", "type", "location", "workflowName", "prefix")
values
('Customer contract', 'contract', 'europe-west4', 'demo_org_a_cust_contract', 'RD');