DROP TABLE tblWeather cascade constraints;
DROP TABLE tblLocation cascade constraints;
DROP SEQUENCE seqWeather;
DROP SEQUENCE seqLocation;

CREATE TABLE tblLocation (
    seq NUMBER PRIMARY KEY, -- 지역번호,
    city VARCHAR2(100) UNIQUE NOT NULL, -- 지역,
    latitude NUMBER NOT NULL,
    longtitude NUMBER NOT NULL
);

CREATE TABLE tblWeather (
		seq NUMBER PRIMARY KEY, -- 날씨번호,
        locationSeq NUMBER NOT NULL REFERENCES tblLocation(seq), -- 지역번호
        observedDate DATE NOT NULL, -- 관측 날짜,
		temperature NUMBER NOT NULL, -- 평균 기온(섭씨),
		humidity NUMBER NOT NULL, -- 습도,
        rain NUMBER NOT NULL -- 강수확률
);

CREATE SEQUENCE seqWeather;
CREATE SEQUENCE seqLocation;

INSERT INTO tblLocation VALUES (seqLocation.nextVal, '경기도 화성시 진안동', 37.21374686550283, 127.03865820159403);

INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-23', 16, 41, 0);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-22', 15, 55, 20);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-21', 13, 90, 85);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-20', 12, 86, 50);
INSERT INTO tblWeather VALUES (seqWeather.nextVal, 1, '2021-03-19', 8, 32, 50);

commit;





