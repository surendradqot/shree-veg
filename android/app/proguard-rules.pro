## Please add these rules to your existing keep rules in order to suppress warnings.
## This is generated automatically by the Android Gradle plugin.
#-dontwarn com.google.devtools.build.android.desugar.runtime.ThrowableExtension
#-dontwarn org.bouncycastle.jsse.BCSSLParameters
#-dontwarn org.bouncycastle.jsse.BCSSLSocket
#-dontwarn org.bouncycastle.jsse.provider.BouncyCastleJsseProvider
#-dontwarn org.conscrypt.Conscrypt$Version
#-dontwarn org.conscrypt.Conscrypt
#-dontwarn org.conscrypt.ConscryptHostnameVerifier
#-dontwarn org.openjsse.javax.net.ssl.SSLParameters
#-dontwarn org.openjsse.javax.net.ssl.SSLSocket
#-dontwarn org.openjsse.net.ssl.OpenJSSE
#-dontwarn com.google.devtools.build.android.desugar.runtime.ThrowableExtension
#-dontwarn java.beans.ConstructorProperties
#-dontwarn java.beans.Transient
#
#
#
##-keep class com.hiennv.flutter_callkit_incoming.** { *; }
##-keepclassmembers class com.hiennv.flutter_callkit_incoming.** { *; }
##-dontshrink
##-keepnames class * {
##    public <init>(...);
##}
-dontwarn com.google.devtools.build.android.desugar.runtime.**
-dontwarn java.beans.ConstructorProperties
-dontwarn java.beans.Transient
-dontwarn org.w3c.dom.bootstrap.DOMImplementationRegistry