create table "public"."document" (
    "id" uuid not null,
    "createdAt" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "instanceId" text not null,
    "dataAreaId" text not null,
    "documentId" text not null,
    "processId" uuid not null
);

alter table "public"."document" enable row level security;

create table "public"."process" (
    "id" uuid not null default gen_random_uuid(),
    "createdAt" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "orderId" smallint not null default '0'::smallint,
    "enable" boolean not null default true,
    "name" text not null,
    "type" text not null,
    "location" text not null,
    "workflowName" text not null,
    "prefix" text not null
);

alter table "public"."process" enable row level security;

CREATE UNIQUE INDEX "document_documentId_key" ON public.document USING btree ("documentId");

CREATE UNIQUE INDEX document_pkey ON public.document USING btree (id);

CREATE UNIQUE INDEX process_pkey ON public.process USING btree (id);

alter table "public"."document" add constraint "document_pkey" PRIMARY KEY using index "document_pkey";

alter table "public"."process" add constraint "process_pkey" PRIMARY KEY using index "process_pkey";

alter table "public"."document" add constraint "document_documentId_key" UNIQUE using index "document_documentId_key";

alter table "public"."document" add constraint "document_processId_fkey" FOREIGN KEY ("processId") REFERENCES process(id) ON DELETE RESTRICT not valid;

alter table "public"."document" validate constraint "document_processId_fkey";