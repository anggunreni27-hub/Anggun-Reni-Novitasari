/**
 * Portfolio Anggun Reni Novitasari
 * Modern, Elegant, and Responsive Personal Portfolio Logic
 */

document.addEventListener('DOMContentLoaded', () => {
  // Elements
  const header = document.getElementById('header');
  const hamburgerBtn = document.getElementById('hamburger-btn');
  const navMenu = document.getElementById('nav-menu');
  const navLinks = document.querySelectorAll('.nav-link');
  const footerBackToTop = document.getElementById('footer-back-to-top');
  const floatingTopBtn = document.getElementById('floating-top-btn');
  const contactForm = document.getElementById('contact-form');
  const toastNotice = document.getElementById('toast-notice');
  const toastMessage = document.getElementById('toast-message');

  /* ==========================================================================
     1. Hamburger Mobile Navigation
     ========================================================================== */
  if (hamburgerBtn && navMenu) {
    hamburgerBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      const isOpen = navMenu.classList.toggle('open');
      hamburgerBtn.setAttribute('aria-expanded', isOpen.toString());
    });

    // Close menu when clicking outside
    document.addEventListener('click', (e) => {
      if (!navMenu.contains(e.target) && !hamburgerBtn.contains(e.target)) {
        navMenu.classList.remove('open');
        hamburgerBtn.setAttribute('aria-expanded', 'false');
      }
    });

    // Close menu when clicking a link
    navLinks.forEach((link) => {
      link.addEventListener('click', () => {
        navMenu.classList.remove('open');
        hamburgerBtn.setAttribute('aria-expanded', 'false');
      });
    });
  }

  /* ==========================================================================
     2. Header Scroll Effect & Scrollspy
     ========================================================================== */
  const sections = document.querySelectorAll('section[id]');

  const handleScroll = () => {
    const scrollY = window.scrollY;

    // Header blur/shadow on scroll
    if (header) {
      if (scrollY > 30) {
        header.classList.add('scrolled');
      } else {
        header.classList.remove('scrolled');
      }
    }

    // Floating Back to Top visibility
    if (floatingTopBtn) {
      if (scrollY > 350) {
        floatingTopBtn.classList.add('visible');
      } else {
        floatingTopBtn.classList.remove('visible');
      }
    }

    // Scrollspy: active nav link detection
    const scrollPosition = scrollY + 120;

    sections.forEach((section) => {
      const sectionTop = section.offsetTop;
      const sectionHeight = section.offsetHeight;
      const sectionId = section.getAttribute('id');

      if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
        navLinks.forEach((link) => {
          if (link.getAttribute('href') === `#${sectionId}`) {
            link.classList.add('active');
          } else {
            link.classList.remove('active');
          }
        });
      }
    });
  };

  window.addEventListener('scroll', handleScroll, { passive: true });
  handleScroll(); // Initial check on load

  /* ==========================================================================
     3. Back To Top Handlers
     ========================================================================== */
  const scrollToTop = () => {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  };

  if (footerBackToTop) {
    footerBackToTop.addEventListener('click', (e) => {
      e.preventDefault();
      scrollToTop();
    });
  }

  if (floatingTopBtn) {
    floatingTopBtn.addEventListener('click', (e) => {
      e.preventDefault();
      scrollToTop();
    });
  }

  /* ==========================================================================
     4. Reveal on Scroll Animation (IntersectionObserver)
     ========================================================================== */
  const animatedElements = document.querySelectorAll('.fade-up-init');

  if ('IntersectionObserver' in window) {
    const observer = new IntersectionObserver(
      (entries, obs) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('in-view');
            obs.unobserve(entry.target);
          }
        });
      },
      {
        threshold: 0.12,
        rootMargin: '0px 0px -40px 0px'
      }
    );

    animatedElements.forEach((el) => observer.observe(el));
  } else {
    // Fallback if IntersectionObserver is not supported
    animatedElements.forEach((el) => el.classList.add('in-view'));
  }

  /* ==========================================================================
     5. Interactive Contact Form & Toast Feedback
     ========================================================================== */
  if (contactForm) {
    contactForm.addEventListener('submit', (e) => {
      e.preventDefault();

      const nameInput = document.getElementById('sender-name');
      const emailInput = document.getElementById('sender-email');
      const messageInput = document.getElementById('sender-message');

      const senderName = nameInput ? nameInput.value.trim() : 'Pengunjung';

      // Show toast notification
      if (toastNotice && toastMessage) {
        toastMessage.textContent = `Terima kasih, ${senderName}! Pesan Anda telah tersimpan dan siap disampaikan kepada Anggun.`;
        toastNotice.classList.add('show');

        // Reset form fields
        contactForm.reset();

        // Hide toast after 4.5 seconds
        setTimeout(() => {
          toastNotice.classList.remove('show');
        }, 4500);
      }
    });
  }
});
