/** @type {import('next').NextConfig} */
const isProd = process.env.NODE_ENV === "production";
const nextConfig = {
  swcMinify: true,
  reactStrictMode: true,
  images: {
    domains: ["img.shields.io"],
  },
  assetPrefix: isProd ? "/reserver/" : "",
  images: {
    unoptimized: true,
  },
};

module.exports = nextConfig;
