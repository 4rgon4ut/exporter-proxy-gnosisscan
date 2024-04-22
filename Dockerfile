# Use the alpine-fat variant which includes LuaRocks
FROM openresty/openresty:alpine-fat

# Install additional packages or dependencies
RUN apk add --no-cache curl gcc git libc-dev make openssl-dev pcre-dev zlib-dev linux-headers

# Use LuaRocks to install any additional Lua modules needed
RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-http

# If you need to customize OpenResty without SSE4.2:
# This step assumes you would clone and build OpenResty from source.
# Uncomment and modify accordingly if this applies.
# RUN apk add build-base perl-dev perl-utils && \
#    wget https://openresty.org/download/openresty-1.19.3.1.tar.gz && \
#    tar -xzvf openresty-1.19.3.1.tar.gz && \
#    cd openresty-1.19.3.1/ && \
#    ./configure --with-cc-opt="-DLUAJIT_NUMMODE=2 -DLUAJIT_ENABLE_LUA52COMPAT -mno-sse4.2" && \
#    make && make install

# Copy your custom Nginx configuration into the container
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

# Expose the necessary ports
EXPOSE 80 443

# Start OpenResty with the default command which keeps the process in the foreground
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
