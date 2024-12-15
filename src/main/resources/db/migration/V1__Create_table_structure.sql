-- Ensure the schema 'vibetribe' exists
CREATE SCHEMA IF NOT EXISTS vibetribe;

-- Table: location
CREATE TABLE IF NOT EXISTS vibetribe.location
(
    id        SERIAL PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL UNIQUE
);

-- Table: user
CREATE TABLE IF NOT EXISTS vibetribe."user"
(
    id                bigserial PRIMARY KEY NOT NULL,
    name              varchar               NOT NULL,
    email             varchar               NOT NULL UNIQUE,
    password          varchar               NOT NULL,
    photo_profile_url varchar,
    referral_code     varchar UNIQUE,
    points_balance    numeric(15, 2)           DEFAULT 0.0,
    role              varchar               NOT NULL,
    website           varchar,
    phone_number      varchar,
    address           varchar,
    created_at        timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at        timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at        timestamp with time zone
);

-- Table: point
CREATE TABLE IF NOT EXISTS vibetribe.point
(
    id               bigserial PRIMARY KEY NOT NULL,
    customer_id      integer               NOT NULL REFERENCES vibetribe."user" (id),
    points_available numeric(15, 2),
    points_used      numeric(15, 2) DEFAULT 0.0,
    is_used          boolean        DEFAULT FALSE,
    expires_at       timestamp with time zone,
    created_at       timestamp with time zone
);

-- Table: event
CREATE TABLE IF NOT EXISTS vibetribe.event
(
    id               bigserial PRIMARY KEY    NOT NULL,
    organizer_id     integer                  NOT NULL REFERENCES vibetribe."user" (id),
    image_url        varchar                  NOT NULL,
    title            varchar                  NOT NULL,
    slug             varchar                  not null unique,
    description      text                     NOT NULL,
    date_time_start  timestamp with time zone NOT NULL,
    date_time_end    timestamp with time zone NOT NULL,
    location         varchar                  NOT NULL,
    location_details varchar                  NOT NULL,
    category         varchar                  NOT NULL,
    fee              numeric(15, 2)           NOT NULL,
    available_seats  integer                  NOT NULL,
    booked_seats     integer                  default 0,
    created_at       timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at       timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at       timestamp with time zone
);

-- Table: review
CREATE TABLE IF NOT EXISTS vibetribe.review
(
    id          bigserial PRIMARY KEY NOT NULL,
    customer_id integer               NOT NULL REFERENCES vibetribe."user" (id),
    event_id    integer               NOT NULL REFERENCES vibetribe.event (id),
    rating      integer,
    review      text,
    created_at  timestamp with time zone
);

-- Table: referral
CREATE TABLE IF NOT EXISTS vibetribe.referral
(
    id            bigserial PRIMARY KEY NOT NULL,
    referral_code varchar REFERENCES vibetribe."user" (referral_code),
    referrer_id   integer,
    referred_id   integer,
    created_at    timestamp with time zone
);

-- Table: voucher
CREATE TABLE IF NOT EXISTS vibetribe.voucher
(
    id            bigserial PRIMARY KEY NOT NULL,
    event_id      integer REFERENCES vibetribe.event (id),
    customer_id   integer REFERENCES vibetribe."user" (id),
    voucher_code  varchar UNIQUE,
    voucher_value numeric(15, 2),
    description   text,
    voucher_type  varchar,
    is_used       boolean DEFAULT FALSE,
    expires_at    timestamp with time zone,
    created_at    timestamp with time zone,
    updated_at    timestamp with time zone
);

-- Table: quantity_based_voucher
CREATE TABLE IF NOT EXISTS vibetribe.quantity_based_voucher
(
    voucher_id     integer PRIMARY KEY REFERENCES vibetribe.voucher (id),
    quantity_limit int,
    quantity_used  int
);

-- Table: date_range_based_voucher
CREATE TABLE IF NOT EXISTS vibetribe.date_range_based_voucher
(
    voucher_id integer PRIMARY KEY REFERENCES vibetribe.voucher (id),
    start_date timestamp with time zone,
    end_date   timestamp with time zone
);

-- Table: voucher_usage
CREATE TABLE IF NOT EXISTS vibetribe.voucher_usage
(
    id          bigserial PRIMARY KEY NOT NULL,
    voucher_id  integer REFERENCES vibetribe.voucher (id),
    customer_id integer REFERENCES vibetribe."user" (id),
    used_at     timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

-- Table: transaction
CREATE TABLE IF NOT EXISTS vibetribe.transaction
(
    id               bigserial PRIMARY KEY NOT NULL,
    customer_id      integer               NOT NULL REFERENCES vibetribe."user" (id),
    event_id         integer               NOT NULL REFERENCES vibetribe.event (id),
    voucher_id       integer REFERENCES vibetribe.voucher (id),
    point_id         integer REFERENCES vibetribe.point (id),
    quantity         integer               NOT NULL,
    points_applied   numeric(15, 2),
    discount_applied numeric(15, 2),
    amount_paid      numeric(15, 2)        NOT NULL,
    created_at       timestamp with time zone
);

-- Table: ticket
CREATE TABLE IF NOT EXISTS vibetribe.ticket
(
    id             bigserial PRIMARY KEY    NOT NULL,
    transaction_id integer                  NOT NULL REFERENCES vibetribe.transaction (id),
    event_id       integer                  NOT NULL REFERENCES vibetribe.event (id),
    customer_id    integer                  NOT NULL REFERENCES vibetribe."user" (id),
    status         varchar                  DEFAULT 'VALID',
    issue_date     timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    valid_from     timestamp with time zone NOT NULL,
    valid_until    timestamp with time zone NOT NULL,
    barcode        varchar UNIQUE,
    price          numeric(15, 2),
    created_at     timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at     timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at     timestamp with time zone
);

-- Indexes for the "user" table
CREATE INDEX IF NOT EXISTS idx_user_email ON vibetribe."user" (email);
CREATE INDEX IF NOT EXISTS idx_user_referral_code ON vibetribe."user" (referral_code);
CREATE INDEX IF NOT EXISTS idx_user_role ON vibetribe."user" (role);

-- Indexes for the "point" table
CREATE INDEX IF NOT EXISTS idx_point_customer_id ON vibetribe.point (customer_id);
CREATE INDEX IF NOT EXISTS idx_point_is_used ON vibetribe.point (is_used);

-- Indexes for the "event" table
CREATE INDEX IF NOT EXISTS idx_event_organizer_id ON vibetribe.event (organizer_id);
CREATE INDEX IF NOT EXISTS idx_event_date_time_start ON vibetribe.event (date_time_start);
CREATE INDEX IF NOT EXISTS idx_event_date_time_end ON vibetribe.event (date_time_end);

-- Indexes for the "review" table
CREATE INDEX IF NOT EXISTS idx_review_customer_id ON vibetribe.review (customer_id);
CREATE INDEX IF NOT EXISTS idx_review_event_id ON vibetribe.review (event_id);

-- Indexes for the "referral" table
CREATE INDEX IF NOT EXISTS idx_referral_referral_code ON vibetribe.referral (referral_code);
CREATE INDEX IF NOT EXISTS idx_referral_referrer_id ON vibetribe.referral (referrer_id);
CREATE INDEX IF NOT EXISTS idx_referral_referred_id ON vibetribe.referral (referred_id);

-- Indexes for the "voucher" table
CREATE INDEX IF NOT EXISTS idx_voucher_event_id ON vibetribe.voucher (event_id);
CREATE INDEX IF NOT EXISTS idx_voucher_customer_id ON vibetribe.voucher (customer_id);
CREATE INDEX IF NOT EXISTS idx_voucher_is_used ON vibetribe.voucher (is_used);

-- Indexes for the "voucher_usage" table
CREATE INDEX IF NOT EXISTS idx_voucher_usage_voucher_id ON vibetribe.voucher_usage (voucher_id);
CREATE INDEX IF NOT EXISTS idx_voucher_usage_customer_id ON vibetribe.voucher_usage (customer_id);
CREATE INDEX IF NOT EXISTS idx_voucher_usage_used_at ON vibetribe.voucher_usage (used_at);

-- Indexes for the "transaction" table
CREATE INDEX IF NOT EXISTS idx_transaction_customer_id ON vibetribe.transaction (customer_id);
CREATE INDEX IF NOT EXISTS idx_transaction_event_id ON vibetribe.transaction (event_id);
CREATE INDEX IF NOT EXISTS idx_transaction_voucher_id ON vibetribe.transaction (voucher_id);
CREATE INDEX IF NOT EXISTS idx_transaction_point_id ON vibetribe.transaction (point_id);

-- Indexes for the "ticket" table
CREATE INDEX IF NOT EXISTS idx_ticket_transaction_id ON vibetribe.ticket (transaction_id);
CREATE INDEX IF NOT EXISTS idx_ticket_event_id ON vibetribe.ticket (event_id);
CREATE INDEX IF NOT EXISTS idx_ticket_customer_id ON vibetribe.ticket (customer_id);
CREATE INDEX IF NOT EXISTS idx_ticket_status ON vibetribe.ticket (status);