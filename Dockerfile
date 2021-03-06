FROM ubuntu
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get install -y postgresql postgresql-contrib && service postgresql start && sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';" && sudo -u postgres createdb liferaydb
RUN echo "" >> /var/lib/postgresql/.psql_history
EXPOSE 5432
RUN echo "host all all 0.0.0.0/0 trust" >> /etc/postgresql/9.3/main/pg_hba.conf

RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf
RUN ln -s /etc/init.d/postgresql /usr/bin/postgresql && chmod 755 /usr/bin/postgresql

ADD start_psql.sh /usr/bin/
RUN chmod 755 /usr/bin/start_psql.sh

ENV PGPASSWORD postgres
USER postgres


CMD /usr/bin/start_psql.sh
