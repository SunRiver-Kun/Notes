<!-- TOC -->

- [CMD](#cmd)
- [Qt](#qt)
    - [QTcp](#qtcp)
    - [QUdp](#qudp)
    - [Qtll](#qtll)
- [Window](#window)
    - [地址](#地址)
    - [TCP](#tcp)
    - [UDP](#udp)
    - [Flags](#flags)

<!-- /TOC -->

# CMD #

查询ip：ping 域名     本机ip：ipconfig
查询dns：https://www.ping.cn/
刷新host、dns：ipconfig /flushdns

# Qt #

注意：Qt中提供的所有的Socket类都是非阻塞的。
设置+Web Sockets

## QTcp ##

TCP/IP   面向连接、基于流、可靠、传输效率低、不能广播
QTcpServer：  SIGNAL：newConnection()    METHOD:  QTcpSocket* nextPendingConnection()
QTcpSocket： SIGNAL：readyRead()、error   METHOD：QByteArray readall()、read、write、
connectToHost()、disconnectFromHost()、waitForConnected(阻塞)、waitForReadyRead(阻塞)、waitForDisconnected(阻塞)

-服务端，嵌套字 QTcpServer负责监听、QTcpSocket负责通信
1.创建套接字	QTcpServer* server = new QTcpServer;          
2.将套接字设置为监听模式     server->listen(QHostAddress::Any, SERVERPORT);   //SERVERPORT 为内网端口
​3.连接，等待 ,读写
server->connect( server, &QTcpServer::newConnection, [=]{
        QTcpSocket* client =  server->nextPendingConnection();   //用于通信
        client->write("Hello client!");
        client->connect( client,&QTcpSocket::readyRead, [client]{
	qDebug(  client->readall() );
	})
} )


-客户端，嵌套字 QTcpSocket
1.创建套接字   	QTcpSocket*  client = new QTcpSocket;
1.2  解析域名	const auto& host = QHostInfo::fromName(ADDRESS);   //ADDRESS为 服务器域名(无http(s))
		const auto& addresses = host.addresses();
		if( addresses.isEmpty() ) {...}
2.连接服务器    connectToHost(QHostAddress(IP),port)  	  client->connectToHost(addresses.first(),PORT);   //PORT 为服务器(临时)端口
3.和服务端一样的读写操作	
client->connect( client,&QTcpSocket::readyRead, [client]{
	qDebug(  client->readall() );
	client->write("The message had been received by client!");
})

## QUdp ##

UDP：嵌套字均为 QUdpSocket，无连接、基于数据报、不可靠、传输效率高、可广播
1.创建套接字
2.绑定套接字后接受，或者不绑定只发送数据
QUdpSocket：
METHOD：hasPendingDatagrams()、joinMulticastGroup()、leaveMulticastGroup、connectToHost()、disconnectToHost()、waitForConnected(阻塞)、waitForReadyRead(阻塞)、waitForDisconnected(阻塞)
bind(QHostAddress::LocalHost,port)
qint64 readDatagram(char * data, qint64 maxSize, QHostAddress * address = 0, quint16 * port = 0)
qint64 writeDatagram(const QByteArray & datagram, const QHostAddress & host, quint16 port)

广播：若 host==QHostAddress::Broadcast，QHostAddress("255.255.255.255")，则局域网的其他UDP用户都接到广播的信息，只能在局域网使用
组播：接收方注册到组播地址才收信息，可在Internet中使用。  
组播的host可选：Ipv4 32位   Ipv6 48位
224.0.0.0～224.0.0.255为预留的组播地址（永久组地址），地址224.0.0.0保留不做分配，其它地址供路由协议使用；
224.0.1.0～224.0.1.255是公用组播地址，可以用于Internet；
224.0.2.0～238.255.255.255为用户可用的组播地址（临时组地址），全网范围内有效；
239.0.0.0～239.255.255.255为本地管理组播地址，仅在特定的本地范围内有效。

注：
局部网内的电脑，直接socket就可以连接了。不同局部网的电脑，需要服务器进行转发。
可以使用utools的内网穿透：
访问地址：域名无http(s)，用于客户端连接
临时端口：用于客户端连接，每连接成功一次，就会变！！！
内网地址：ip地址，或域名(无http(s))。 cmd -> ipconfig
内网端口：不用0~1024，基本都可以。也可以 cmd -> netstat -ano

## Qtll ##

相关类：
<QtNetwork/QtNetwork>    pro += network;
QAuthenticator：认证对象
QDnsLookup：DNS查找    SIGNAL: finished()     METHOD: lookup()、setTyoe()
QDns DomainName/HostAddress/MailExchange/Service/Text Record
QHostAddress：host的ip地址(别名)  METHOD: ::LocalHost()、::Broadcast()、::lookupHost()    
QHostInfo：获取host信息，   METHOD:  ::fromName()、::localHostName()、::lookupHost

QHttpMultiPart：与HTTP上传输的MIEM multipart类相似的类
QHttpPart：包含报头和正文，header：General/Request/Reponse/Entity

QLocalServer：基于服务器的本地套接字
QLoaclSocket：支持本地套接字的类

QNetworkAccessManager：收发网络信息(http)       SIGNAL: finished(QNetworkReply*)、  METHOD: get(QNetworkRequest)、sendCustomRequest
QNetworkRequest：请求，包含头信息和加密头信息
QNetworkReply：回应

QNetworkAddressEntry：存储IP、网络掩码等网络消息的类
QNetworkCacheMetaData：缓存消息
QNetworkConfiguration：设置网络接口点，启动/停止网络接口连接
QNetworkConfigurationManager：管理网络设备
QNetworkCookie：设置网络cookie的类
QNetworkCookieJar：实现QNetworkCookie对象的单一Jar的类
QNetworkDiskCache：基本的磁盘缓存
QNetworkInterface：主机网络IP和网络接口列表   METHOD:  :: allAddresses()
QNetworkProxy：网络层代理
QNetworkProxyFactory：网络层代理的扩展类
QNetworkProxyQuery：在套接字查询代理设置的类
QNetworkSession：管理网络可访问的接入点和平台的接入点的类。网络会话

QSocketNotifier：监控网络公告消息的类

QSslCertificate：X509认证API
QSslCertificateExtension：提供X509证书的扩展API
QSslCipher：支持SSL加密认证的类
QSslConfiguration：指定SSL连接状态和设置的类
QSslError：处理SSL错误
QSslkey：私有密钥和公共密钥接口
QSslSocket：SSL加密套接字

QTcpServer：TCP服务器专用套接字
QTcpSocket：TCP套接字，用于服务端中处理客户端信息或客户端连接
QUdpSocket：UDP套接字
QUrl：至此通过URL运行的接口    METHOD：  ::fromLocalFile

-------------------------------------------------
# Window #
通常平台无关的函数都是全小写的，平台相关的会加前缀（如 WSA）
函数正常返回0，否则返回其他值（大部分-1， SOCKET_ERROR(WINDOW)）
    <Windows.h> 中有早期的socket版本，要避免包含，或在前定义 WIN32_LEAN_AND_MEAN 的宏

            socket启动状态        socket清理                获取具体错误（立刻调用）            头文件
Window：    需要WSAStartup       同等次数的WSACleanup      WSAGetLastError                   <WinSock2.h>
POSIX：     默认激活                                           errno                    <sys/socket.h> <netinet/in.h>(IPv4) <arpa/inet.h>(地址转换) <netdb.h>(DNS)

```
#include <WinSock2.h>
#pragma comment(lib,"ws2_32")

TCP					                   UDP
Server：		Client：			Both：
WSAStartup()	WSAStartup()		WSAStartup()
socket()		socket()			socket()
bind()		    [bind()]			bind()	//绑定IP和端口，不绑定则在send/recv时自动绑定个（客户端）
listen()		--------			
accept()		--------			
阻塞等待  <-->   connect()			 
recv()/send()	send()/recv()		recvfrom()/sendto()   // 0连接中，>0数据量，<0错误
closesocket()	closesocket()		closesocket()
WSACleanup()	WSACleanup()		WSACleanup()
```

definde SOCKET int（POSIX系列，Mac, Linux, PS） || UINT_PTR（Window） 

int WSAStartup(WORD versionRequest, LPWSADATA out_data)     --> versionRequest=MAKEWORD(2（主版本号）,2（次版本号）)      out_data是WSADATA的指针， 输出版本、socket信息等   

/*
    af(agreement family, 协议族): AF_UNSPEC（未指定）, AF_INET（IPv4）, AF_INET6（IPv6）,     AF_IPX（分组交换，早期）, AF_APPLETALK（苹果网络，早期）
    type: SOCK_STREAM（有序可靠）, SOCK_DGRAM（无序离散）, SOCK_RAW（自定义头部）, SOCK_SEQPACKET（TCP，但数据整体读取） 
    protocol: IPPROTO_UDP, IPPROTO_TCP, IPPROTO_IP(0, 根据type来STEAM->TCP, DGRAM->UDP)
*/
SOCKET socket(int af, int type, int protocol)
int closesocket(SOCKET sock)
int shutdown(SOCKET sock, int how)  //how: SD_SEND（产生FIN），SD_RECEIVE，SD_BOTH

## 地址 ##
struct sockaddr{            // 不常用，仅在给函数传参时转换而已
    uint16_t sa_family;     // AF_UNSPEC（未指定）AF_INET（IPv4）AF_INET6（IPv6）
    cha sa_data[14];        // 数据
}

struct sockaddr_in{
    short sin_family;       // AF_UNSPEC（未指定）AF_INET（IPv4）AF_INET6（IPv6）
    unit16_t sin_port;      // 端口号， 设置为0则随机找一个
    struct in_addr sin_addr;    //INADDR_ANY（任意地址）
    char sin_zero[8];   //要设置为0。  memset(&addr, 0, sizeof(addr)) 。
}
struct in_addr{
    union {
        struct { uint8_t s_b1, s_b2, s_b3, s_b4; } S_un_b;
        struct { uint16_t s_w1, s_w2; } S_un_w;
        uint32_t S_addr;
    } S_un;
}

//设置IP地址（IPv4）
addr.sin_addr.s_addr = inet_addr("192.168.0.1");
inet_pton(AF_INET, "192.168.0.1", &addr.sin_addr)   //字符串转入Ip地址，*成功返回1，源字符串错误返回0，其他错误返回-1*
// inet_ntop(AF_INET, &clientAddr.sin_addr, clientIP:char[], sizeof(clientIP))  IP地址转字符串
addr.sin_addr.s_addr = INADDR_ANY;   //0.0.0.0  监听所有本地IP

//DNS查询
/*
    hostname: 域名， "baidu.com"
    servname: 端口号或对应服务名，"80" or "http"
    hints: 用来进行提示，ai_flags（AI_CANONNAME），ai_protocol，ai_socktype，ai_family（AF_INET, AF_INET6）
    result: 传入接受数据的指针的地址，  addrinfo* result,  &result

    return：0正常，其他使用 gai_strerror(result) 来获取错误（EAI_NONAME主机不存在，EAI_AGAIN临时错误）
*/
int getaddrinfo(const char* hostname, const char* servname, const addrinfo* hints, addrinfo** result)
void freeaddrinfo(addrinfo* result);     //释放result链表的内存

注意：getaddrinfo是阻塞的，可能要若干秒才返回。 Window上可以用GetAddrInfoEx来异步获取

struct addrinfo{
    int ai_flags;    //AI_CANONNAME（客户端请求标准名字，第一个ai_canonname）, AI_PASSIVE（服务器绑定）
    
    int ai_family;  //AF_INET, AF_INET6
    int ai_socktype;    //SOCK_STREAM（有序可靠）, SOCK_DGRAM（无序离散）, SOCK_RAW（自定义头部）, SOCK_SEQPACKET（TCP，但数据整体读取）
    int ai_protocol;    //IPPROTO_UDP, IPPROTO_TCP, IPPROTO_IP(0, 根据type来STEAM->TCP, DGRAM->UDP)

    size_t ai_addrlen;  //返回的地址数组长度
    sockaddr* ai_addr;  //返回的地址数组

    char* ai_canonname; //当ai_flags设置AI_CANONNAME时，返回标志名字

    addrinfo* ai_next;
}

TCP/IP协议族 和 主机在多字节数的字节序上可能有差异，所以要转换。
htons(), htonl(), host to net short/long.  传入 sockadd_in 时
ntohs(), ntohl(), net to host short/long.  解析 sockadd_in 时

## TCP ##
需要给每个连接创建一个socket

服务器：
int bind(SOCKET sock, sockaddr* self_addr, int addrlen);    //绑定本机的IP地址和端口，不绑定发送或接受时会自动绑定个
int listen(SOCKET sock, int backlog)    //把socket变成被动的接受，并设置缓存的连接队列长度，等待accept处理。 
SOCKET accept(SOCKET sock, sockaddr* out_addr, int* out_arrlen)  //返回和客户端连接的socket，端口和监听端口相同，out_addr需要使用inet_ntop, ntohs来转换成显示的IP和端口

客户端:
int connect(SOCKET sock, const sockaddr* server_addr, int addrlen)  //给服务器发送SYN，来启动三次握手，服务器通过accept回应

三次握手后：
int send(SOCKET sock, const char* buf, int len, int flags)  //>0实际发送的字节数，0对面关闭连接 ，<0错误
int recv(SOCKET sock, char* buf, int len, int flags)    //从socket缓存区输出数据到buf，并删除socket缓冲区的内容。 >0 接收数据的量，0接受到FIN ，<0错误

## UDP ##
UDP是不可靠的，只需要一个socket即可来给发送和接受数据

int sendto(SOCKET sock, const char* buf, int len, int flags, const sockaddr* to, int tolen) //向某地址发送数据，>=0加入发送队列，<0错误
int recvfrom(SOCKET sock, const char* buf, int len, int flags, const sockaddr* out_from, int fromlen)   //接受来着任意地址的数据

## Flags ##
send，recv，sendto，recvfrom的falgs设置。

send的flags
0	默认行为（阻塞）
MSG_OOB	发送带外数据（紧急数据）
MSG_DONTWAIT	非阻塞发送
MSG_NOSIGNAL	连接断开时不发送SIGPIPE信号

