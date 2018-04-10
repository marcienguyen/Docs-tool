
**1. Yêu cầu:**

- Cài đặt Docker

**2. Hướng dẫn**

- Chỉnh sửa css: mở file docs/css/extra.css và chỉnh sửa. Sau khi biên dịch mkdocs build thì file css sẽ được add vào trong theme.
- Chỉnh sửa js: tương tự mở file docs/js/extra.js.
- Thư mục mytheme: là thư mục theme với file main.html là file chính, từ file này sẽ include các file thành phần khác như header, footer, nav, toc.
Theme sử dụng engine http://jinja.pocoo.org/docs/2.9/, tham khảo để biết thêm chi tiết.

**3. Phương thức hoạt động**

Khi chỉnh sửa theme xong chỉ cần chạy lệnh sau để tự động clone code mới từ github vào trong container.
```
docker run -it --rm -d --name docs_tool -e RE_BUILD="https://github.com/Magestore/Docs-tool.git" docs_tool
```
Lưu ý cần phải chạy lênh sau để build docker image trước khi chạy lệnh trên
```
docker build --rm -t docs_tool .
```
Sau khi mkdocs build xong thì trong script mkdocs_build.sh sẽ tự động push thư mục docs lên https://github.com/Magestore/Docs trên nhánh 
gh-pages (là nhánh github page)

**4. Cấu hình web github page và custom theme**

Tại setting của github page của https://github.com/Magestore/Docs/settings ta lấy được link github page tương ứng https://magestore.github.io/Docs/
Tại nơi cấu hình domain docs.magestore.com trỏ vào ip 130.211.157.247, trên đó có cấu hình virtual host cho https và proxy đến link https://magestore.github.io/Docs/
```
        ## Proxy to blog server
        ProxyPreserveHost Off
        #ProxyRequests Off
        SSLProxyEngine on
        SSLProxyVerify none
        SSLProxyCheckPeerCN off
        SSLProxyCheckPeerName off
        SSLProxyCheckPeerExpire off

        ProxyPass "/" https://magestore.github.io/Docs/
        ProxyPassReverse "/" https://magestore.github.io/Docs/
        ProxyPassReverse "/" http://magestore.github.io/Docs/
```
> _**Lưu ý:** nếu làm theo hướng dẫn custom domain của github page thì sẽ không có được certificate cho https_
