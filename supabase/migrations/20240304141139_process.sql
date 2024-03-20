create table "public"."document" (
    "id" uuid not null default gen_random_uuid(),
    "createdAt" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "name" text not null
);

alter table "public"."document" enable row level security;

CREATE UNIQUE INDEX document_pkey ON public.document USING btree (id);

alter table "public"."document" add constraint "document_pkey" PRIMARY KEY using index "document_pkey";
