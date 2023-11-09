CREATE TYPE filetype AS ENUM ('Image', 'Video', 'Text', 'Manga', 'Other');
CREATE TYPE filestate AS ENUM ('processing', 'error', 'private', 'public');
CREATE TABLE files (
    id BIGSERIAL PRIMARY KEY,
    hash CHARACTER VARYING(32) UNIQUE,
    filename CHARACTER VARYING NOT NULL UNIQUE,
    owner CHARACTER VARYING DEFAULT 'deleted' REFERENCES users (username) ON DELETE SET DEFAULT ON UPDATE CASCADE,
    description CHARACTER VARYING DEFAULT '',
    upload_time timestamp with time zone NOT NULL,
    size CHARACTER VARYING NOT NULL,
    type filetype NOT NULL DEFAULT 'Other',
    state filestate NOT NULL DEFAULT 'processing'
);

CREATE TABLE images (
    file_hash CHARACTER VARYING(32) PRIMARY KEY REFERENCES files (hash) ON DELETE CASCADE ON UPDATE CASCADE,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    phash BIGINT NOT NULL,
    colorhash BIGINT NOT NULL
);

CREATE TABLE videos (
    file_hash CHARACTER VARYING(32) PRIMARY KEY REFERENCES files (hash) ON DELETE CASCADE ON UPDATE CASCADE,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    duration INTEGER NOT NULL,
    has_audio BOOLEAN NOT NULL
);

CREATE TABLE stories (
    file_hash CHARACTER VARYING(32) PRIMARY KEY REFERENCES files (hash) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE mangas (
    file_hash CHARACTER VARYING(32) PRIMARY KEY REFERENCES files (hash) ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE categories (
    category CHARACTER VARYING PRIMARY KEY
);

CREATE TABLE tags (
    tag CHARACTER VARYING PRIMARY KEY,
    category CHARACTER VARYING DEFAULT 'Common' REFERENCES categories (category) ON DELETE SET DEFAULT ON UPDATE CASCADE
);

CREATE TABLE files_tags (
    id BIGSERIAL PRIMARY KEY,
    file_hash CHARACTER VARYING(32) REFERENCES files (hash) ON DELETE CASCADE ON UPDATE CASCADE,
    tag CHARACTER VARYING REFERENCES tags (tag) ON DELETE CASCADE ON UPDATE CASCADE
);


-- select hash, array_agg(tag) from files
-- join files_tags on files.hash = files_tags.file_hash
-- group by hash



-- HAMMING:->>>>>   bit_count(phash # oth_phash) <<<<<--!!!!!!! # - XOR
-- select bit_count(images.phash::bit(64) # (-3906285507453321988)::bit(64)) from images left join files on images.hash=files.hash;