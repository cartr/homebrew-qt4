class QtWebkitAT23 < Formula
  desc "Qt port of WebKit (insecure, don't use for Web browsing)"
  homepage "https://trac.webkit.org/wiki/QtWebKit"
  url "https://download.kde.org/stable/qtwebkit-2.3/2.3.4/src/qtwebkit-2.3.4.tar.gz"
  sha256 "c6cfa9d068f7eb024fee3f6c24f5b8b726997f669007587f35ed4a97d40097ca"
  revision 1

  depends_on "cartr/qt4/qt@4"

  # Put data and import files into this formula's cellar instead of installing them globally.
  patch :DATA

  def install
    ENV["QTDIR"] = Formula["cartr/qt4/qt@4"].opt_prefix
    ENV["INSTALL_DATA"] = "#{prefix}/etc/qt4"
    ENV["INSTALL_LIBS"] = lib
    system "Tools/Scripts/build-webkit", "--qt", "--no-webkit2", "--no-video", "--install-headers=#{include}", "--install-libs=#{lib}", "--minimal"
    system "make", "-C", "WebKitBuild/Release", "install"
  end

  def caveats; <<~EOS
    This is years old and really insecure. You shouldn't
    use it if you don't absolutely trust the HTML files 
    you're using it to browse. Definely avoid using it
    in a general-purpose Web browser.
    
    Also, video doesn't work.
    EOS
  end
  
  bottle do
    root_url "https://dl.bintray.com/cartr/autobottle-qt4"
    sha256 "5dd5a1c9a191e9d2c4245cad33db18044fcb501f9af3128916827eba44282ebb" => :high_sierra
    sha256 "e01b4ee5cc9abc69bebf01f104ea9d74f3af840160d977e6d81f80d5b8bf5e4f" => :sierra
    sha256 "fd1d1b30bb87d94e140dcdfee41ac69383b590c6166deee4056c06fa638dc8ff" => :el_capitan
    sha256 "3b88371ffd6fb1a671e47867a9cc3561bcb4af65cc9c6dde644d9cb4aac6311d" => :yosemite
  end
end

__END__
diff --git a/Source/WebKit/qt/declarative/experimental/experimental.pri b/Source/WebKit/qt/declarative/experimental/experimental.pri
index 8e8d528..97075f5 100644
--- a/Source/WebKit/qt/declarative/experimental/experimental.pri
+++ b/Source/WebKit/qt/declarative/experimental/experimental.pri
@@ -38,10 +38,7 @@ DEFINES += HAVE_WEBKIT2
 
 WEBKIT += wtf javascriptcore webkit2
 
-# The fallback to QT_INSTALL_IMPORTS can be removed once we
-# depend on Qt 5 RC1.
-importPath = $$[QT_INSTALL_QML]
-isEmpty(importPath): importPath = $$[QT_INSTALL_IMPORTS]
+importPath = $$(INSTALL_LIBS)/qt4/imports
 
 target.path = $${importPath}/$${TARGET.module_name}
 
diff --git a/Source/WebKit/qt/declarative/public.pri b/Source/WebKit/qt/declarative/public.pri
index 7cb3bbf..77e80d0 100644
--- a/Source/WebKit/qt/declarative/public.pri
+++ b/Source/WebKit/qt/declarative/public.pri
@@ -46,10 +46,7 @@ SOURCES += plugin.cpp
     QT += network
 }
 
-# The fallback to QT_INSTALL_IMPORTS can be removed once we
-# depend on Qt 5 RC1.
-importPath = $$[QT_INSTALL_QML]
-isEmpty(importPath): importPath = $$[QT_INSTALL_IMPORTS]
+importPath = $$(INSTALL_LIBS)/qt4/imports
 
 target.path = $${importPath}/$${TARGET.module_name}
 
diff --git a/Source/api.pri b/Source/api.pri
index f9d6fbc..413eb9b 100644
--- a/Source/api.pri
+++ b/Source/api.pri
@@ -118,7 +118,7 @@ haveQt(5) {
 } else {
     # For Qt4 we have to set up install rules manually
     modulefile.files = $${ROOT_WEBKIT_DIR}/Tools/qmake/qt_webkit.pri
-    mkspecs = $$[QMAKE_MKSPECS]
+    mkspecs = $$(INSTALL_DATA)/mkspecs
     mkspecs = $$split(mkspecs, :)
     modulefile.path = $$last(mkspecs)/modules
     INSTALLS += modulefile
