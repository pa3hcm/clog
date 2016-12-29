Name: clog
Summary: CLog - Command-line logbook for amateur radio
Version: 1.1
Release: 1
Group: Applications/Applications
License: GPL
Source: %{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch: noarch
Requires: mysql-server >= 3.23.23
Requires: perl perl-DBI perl-DBD-MySQL
Packager: Ernest Neijenhuis PA3HCM <pa3hcm amsat org>


%description
CLog is a command-line logbook for amateur radio. There is no other
interface available. If you don't like working on a command-line, forget this
software. There's no GUI or whatever. However, if you can't live without your
command-line, you might love it. At least I do :-)


%prep
%setup -q


%build


%install
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}
mkdir -p %{buildroot}%{_bindir}/
mkdir -p %{buildroot}%{_mandir}/man1/
install -m755 %{name} %{buildroot}%{_bindir}/
install -m644 %{name}.1.gz %{buildroot}%{_mandir}/man1/


%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}


%files
%defattr(-,root,root)
%doc CHANGES COPYING README TODO clog.sql example.clogrc wp-clog.php
%attr(0755,root,root) %{_bindir}/%{name}
%attr(0644,root,root) %{_mandir}/man1/%{name}.1.gz


%post
echo " "
echo "NOTICE: Before using CLog, please read the README file to"
echo "        see how to initialize or upgrade the database."
echo "        The README file is located in /usr/share/doc/%{name}-%{version}"
echo " "


%changelog
* Thu Dec 29 2016 Ernest Neijenhuis PA3HCM <pa3hcm amsat org> 1.1-1
- Updated to CLog 1.1.

* Mon May 18 2015 Ernest Neijenhuis PA3HCM <pa3hcm amsat org> 1.0-1
- Updated to CLog 1.0.

* Thu Jul 10 2014 Ernest Neijenhuis PA3HCM <pa3hcm amsat org> 0.11b-1
- Updated to CLog 0.11b.

* Fri Jun 06 2014 Ernest Neijenhuis PA3HCM <pa3hcm amsat org> 0.10b-1
- Updated to CLog 0.10b.

* Sun Dec 09 2012 Ernest Neijenhuis PA3HCM <pa3hcm amsat org> 0.9b-1
- Updated to CLog 0.9b.

* Mon Feb 06 2012 Ernest Neijenhuis PA3HCM <pa3hcm amsat org> 0.8b-1
- Updated to CLog 0.8b.

* Sun Jan 30 2011 Ernest Neijenhuis PA3HCM <pa3hcm amsat org> 0.7b-1
- Updated to CLog 0.7b.

* Thu Jul 16 2009 Ernest Neijenhuis PA3HCM <pa3hcm amsat org> 0.6b-1
- Updated to CLog 0.6b.

* Thu Feb 19 2009 Ernest Neijenhuis PA3HCM <pa3hcm amsat org> 0.5b-1
- Updated to CLog 0.5b.
- Added a post install message about initializing/upgrading the database.

* Thu Feb 17 2009 Ernest Neijenhuis PA3HCM <pa3hcm amsat org> 0.4b-1
- Updated to CLog 0.4b.

* Thu Feb 13 2009 Ernest Neijenhuis PA3HCM <pa3hcm amsat org> 0.3b-1
- First version of this spec-file.

