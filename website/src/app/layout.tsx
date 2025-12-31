import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  metadataBase: new URL("https://puppypro.app"),
  title: "PuppyPro - Smart Dog Training",
  description: "Train smarter, not harder. Transform your pup into a well-behaved companion with positive reinforcement techniques.",
  keywords: ["dog training", "puppy training", "dog clicker", "pet training app", "positive reinforcement"],
  openGraph: {
    title: "PuppyPro - Smart Dog Training",
    description: "Transform your pup into a well-behaved companion with positive reinforcement techniques.",
    type: "website",
    url: "https://puppypro.app",
    images: [
      {
        url: "/og-image.png",
        width: 1200,
        height: 630,
        alt: "PuppyPro App",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "PuppyPro - Smart Dog Training",
    description: "Transform your pup into a well-behaved companion with positive reinforcement techniques.",
  },
  icons: {
    icon: [
      { url: "/favicon-16.png", sizes: "16x16", type: "image/png" },
      { url: "/favicon-32.png", sizes: "32x32", type: "image/png" },
    ],
    apple: "/apple-touch-icon.png",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">
        {children}
      </body>
    </html>
  );
}
