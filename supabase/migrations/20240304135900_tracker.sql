create table "public"."tracker" (
    "id" uuid not null default gen_random_uuid(),
    "createdAt" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "callbackUrl" text,
    "executionId" text not null,
    "locationId" text not null,
    "projectId" text not null,
    "metadata" json,
    "type" text not null,
    "roleId" text
);


alter table "public"."tracker" enable row level security;

CREATE UNIQUE INDEX tracker_pkey ON public.tracker USING btree (id);

alter table "public"."tracker" add constraint "tracker_pkey" PRIMARY KEY using index "tracker_pkey";