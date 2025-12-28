import type { Metadata, Viewport } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
  display: "swap",
  preload: true,
});

export const viewport: Viewport = {
  themeColor: "#0D9488",
  width: "device-width",
  initialScale: 1,
};

export const metadata: Metadata = {
  title: "Puppy Pro - Dog Trainer | Pay Once, Train Forever",
  description: "The dog training app that respects your wallet and your time. No subscriptions. No account required. Track progress, master commands, train any dog.",
  keywords: ["dog training", "puppy training", "dog trainer app", "puppy pro", "dog commands", "pet training", "dog obedience", "puppy tracker"],
  authors: [{ name: "Puppy Pro" }],
  metadataBase: new URL("https://puppypro.app"),
  alternates: {
    canonical: "/",
  },
  robots: {
    index: true,
    follow: true,
  },
  openGraph: {
    title: "Puppy Pro - Dog Trainer | Pay Once, Train Forever",
    description: "Professional dog training app for $39 one-time. No subscriptions, unlimited dogs, works offline. 4.9★ rated.",
    type: "website",
    locale: "en_US",
    siteName: "Puppy Pro",
    images: [
      {
        url: "/og-image.png",
        width: 1200,
        height: 630,
        alt: "Puppy Pro - Dog Trainer - Pay Once, Train Forever - $39",
      }
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "Puppy Pro - Dog Trainer | Pay Once, Train Forever",
    description: "Professional dog training app for $39 one-time. No subscriptions, unlimited dogs, works offline.",
    images: ["/og-image.png"],
  },
};

// JSON-LD Structured Data
const jsonLd = {
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  name: "Puppy Pro - Dog Trainer",
  applicationCategory: "LifestyleApplication",
  operatingSystem: "iOS",
  offers: {
    "@type": "Offer",
    price: "39",
    priceCurrency: "USD",
  },
  aggregateRating: {
    "@type": "AggregateRating",
    ratingValue: "4.9",
    ratingCount: "500",
  },
  description: "The dog training app that respects your wallet and your time. Track progress, master commands, train any dog.",
};

const organizationSchema = {
  "@context": "https://schema.org",
  "@type": "Organization",
  name: "Puppy Pro",
  url: "https://puppypro.app",
  logo: "https://puppypro.app/icon.png",
  sameAs: [],
  description: "Professional dog training app with one-time payment. No subscriptions, unlimited dogs, works offline.",
  contactPoint: {
    "@type": "ContactPoint",
    contactType: "customer support",
    email: "support@puppypro.app",
  },
};

const websiteSchema = {
  "@context": "https://schema.org",
  "@type": "WebSite",
  name: "Puppy Pro",
  url: "https://puppypro.app",
  description: "Professional dog training app with one-time payment. No subscriptions, unlimited dogs, works offline.",
};

const faqSchema = {
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "Is this really a one-time payment? No hidden fees?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, really. You pay once, you own it forever. No subscription. No introductory pricing that jumps after a month. No sneaky auto-renewals."
      }
    },
    {
      "@type": "Question",
      "name": "Do I need to create an account?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Nope. Download the app, open it, add your dog, start training. No email required. No password to remember."
      }
    },
    {
      "@type": "Question",
      "name": "How many dogs can I add?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Puppy Plan: 1 dog. Pack Leader & Family Plans: Unlimited dogs. Add as many dogs as you want with no per-dog fees."
      }
    },
    {
      "@type": "Question",
      "name": "Does it work offline?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "100%. Every feature works without an internet connection. Everything syncs automatically when you're back online."
      }
    },
    {
      "@type": "Question",
      "name": "What if I change phones?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Your data follows you through iCloud sync. Get a new iPhone, download the app, sign into iCloud, and everything will be there."
      }
    },
    {
      "@type": "Question",
      "name": "Is there a free trial?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "No, but we offer a 30-day money-back guarantee. Buy the app, use it fully, and if you don't love it, email us for a complete refund."
      }
    },
    {
      "@type": "Question",
      "name": "How is this different from other dog training apps?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "One-time payment vs subscription ($39 vs $1,128 over 2 years). No account required. Unlimited dogs. Full offline mode. Built-in clicker."
      }
    },
    {
      "@type": "Question",
      "name": "What's included in lifetime updates?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Everything we build, you get. New features, commands, training guides, improvements - all free for existing customers forever."
      }
    }
  ]
};

const reviewSchema = {
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "Puppy Pro - Dog Trainer",
  "description": "Professional dog training app with one-time payment",
  "brand": {
    "@type": "Brand",
    "name": "Puppy Pro"
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.9",
    "reviewCount": "500",
    "bestRating": "5",
    "worstRating": "1"
  },
  "review": [
    {
      "@type": "Review",
      "author": {"@type": "Person", "name": "Jessica T."},
      "datePublished": "2024-11-15",
      "reviewRating": {"@type": "Rating", "ratingValue": "5", "bestRating": "5"},
      "reviewBody": "When we brought Mochi home, I was completely overwhelmed. Within 3 weeks, Mochi learned sit, stay, down, and come."
    },
    {
      "@type": "Review",
      "author": {"@type": "Person", "name": "Marcus L."},
      "datePublished": "2024-10-22",
      "reviewRating": {"@type": "Rating", "ratingValue": "5", "bestRating": "5"},
      "reviewBody": "Worth every penny. Duke went from pulling on every walk to loose-leash walking in about 6 weeks."
    },
    {
      "@type": "Review",
      "author": {"@type": "Person", "name": "Rachel & Tom K."},
      "datePublished": "2024-09-30",
      "reviewRating": {"@type": "Rating", "ratingValue": "5", "bestRating": "5"},
      "reviewBody": "Finally, one app for all three of my dogs. The unlimited dogs feature alone made this worth it."
    }
  ],
  "offers": {
    "@type": "AggregateOffer",
    "lowPrice": "19",
    "highPrice": "59",
    "priceCurrency": "USD",
    "offerCount": "3"
  }
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="scroll-smooth">
      <head>
        {/* Preload hero image for better LCP */}
        <link
          rel="preload"
          as="image"
          href="/screenshots/progress-dashboard.png"
          fetchPriority="high"
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }}
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(reviewSchema) }}
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationSchema) }}
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(websiteSchema) }}
        />
      </head>
      <body className={`${inter.variable} font-sans antialiased`}>
        {/* Skip to main content link for accessibility */}
        <a
          href="#main-content"
          className="sr-only focus:not-sr-only focus:fixed focus:left-4 focus:top-4 focus:z-50 focus:rounded-md focus:bg-primary focus:px-4 focus:py-2 focus:text-primary-foreground"
        >
          Skip to main content
        </a>
        {children}
      </body>
    </html>
  );
}
