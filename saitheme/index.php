<!DOCTYPE html>
<html <?php language_attributes(); ?>>

<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Saif | Personal Website</title>

    <?php wp_head(); ?>
</head>

<body <?php body_class(); ?>>

    <header class="site-header">

        <div class="container header-inner">

            <a href="<?php echo esc_url(home_url('/')); ?>" class="site-brand">

                <div class="site-logo">
                    S
                </div>

                <div class="site-title">
                    SAIF
                </div>

            </a>

            <nav class="main-navigation">

                <a href="#home">Home</a>
                <a href="#about">Tentang</a>
                <a href="#projects">Project</a>
                <a href="#contact">Kontak</a>

            </nav>

        </div>

    </header>


    <main>

        <!-- HERO -->

        <section class="hero" id="home">

            <div class="container">

                <div class="hero-content">

                    <div class="hero-label">
                        Personal Website
                    </div>

                    <h1>
                        Halo, saya <span>Saif.</span>
                    </h1>

                    <p>
                        Saya sedang belajar membuat website dan
                        mengembangkan kemampuan saya di bidang teknologi.
                    </p>

                    <div class="hero-actions">

                        <a href="#projects" class="hero-button">
                            Lihat Project
                        </a>

                        <a href="#about" class="hero-link">
                            Tentang Saya →
                        </a>

                    </div>

                </div>

                <div class="hero-card">

                    <div class="hero-card-top">
                        <span></span>
                        <span></span>
                        <span></span>
                    </div>

                    <div class="hero-code">

                        <span>&lt;beginner&gt;</span>

                        <strong>Saif</strong>

                        <small>
                            Sedang belajar web development
                        </small>

                        <span>&lt;/beginner&gt;</span>

                    </div>

                </div>

            </div>

        </section>


        <!-- ABOUT -->

        <section class="section" id="about">

            <div class="container">

                <div class="section-label">
                    TENTANG
                </div>

                <h2>
                    Tentang Saya
                </h2>

                <p class="section-description">
                    Saya Saif, seorang pemula yang sedang belajar
                    membuat website. Saya masih dalam proses belajar
                    HTML, CSS, PHP, WordPress, dan berbagai teknologi web.
                </p>

            </div>

        </section>


        <!-- PROJECTS -->

        <section class="section section-gray" id="projects">

            <div class="container">

                <div class="section-label">
                    PROJECT
                </div>

                <h2>
                    Project yang Saya Kerjakan
                </h2>

                <div class="project-grid">

                    <article class="project-card">

                        <div class="project-number">
                            01
                        </div>

                        <h3>
                            Website Pertama
                        </h3>

                        <p>
                            Project website sederhana yang saya buat
                            sebagai bagian dari proses belajar.
                        </p>

                        <a href="#">
                            Lihat Project →
                        </a>

                    </article>


                    <article class="project-card">

                        <div class="project-number">
                            02
                        </div>

                        <h3>
                            Belajar WordPress
                        </h3>

                        <p>
                            Mencoba membuat dan mengembangkan tema
                            WordPress sendiri.
                        </p>

                        <a href="#">
                            Lihat Project →
                        </a>

                    </article>


                    <article class="project-card">

                        <div class="project-number">
                            03
                        </div>

                        <h3>
                            Latihan UI / UX
                        </h3>

                        <p>
                            Mencoba membuat tampilan website yang
                            sederhana, bersih, dan mudah digunakan.
                        </p>

                        <a href="#">
                            Lihat Project →
                        </a>

                    </article>

                </div>

            </div>

        </section>


        <!-- CONTACT -->

        <section class="section" id="contact">

            <div class="container contact-box">

                <div>

                    <div class="section-label">
                        KONTAK
                    </div>

                    <h2>
                        Mari berkenalan.
                    </h2>

                    <p>
                        Jika ingin berdiskusi, berbagi ide, atau
                        sekadar menyapa, kamu bisa menghubungi saya.
                    </p>

                </div>

                <a
                    href="mailto:emailkamu@example.com"
                    class="hero-button">
                    Hubungi Saya
                </a>

            </div>

        </section>

    </main>


    <footer class="site-footer">

        <div class="container footer-inner">

            <div>
                © <?php echo date('Y'); ?> Saif
            </div>

            <div>
                Personal Website
            </div>

        </div>

    </footer>


    <?php wp_footer(); ?>

</body>

</html>